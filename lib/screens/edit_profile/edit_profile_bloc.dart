import 'package:bloc/bloc.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/screens/home/profile/profile_bloc.dart';
import 'edit_profile_events.dart';
import 'edit_profile_states.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UserSession _userSession;
  final UserRepository _userRepository;
  final UserProfileBloc userProfileBloc;
  EditProfileBloc(
      this._userSession, this._userRepository, this.userProfileBloc);
  @override
  EditProfileState get initialState => IdleState();
  @override
  void onTransition(Transition<EditProfileEvent, EditProfileState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    try {
      if (event is UpdateAccountInformationEvent) {
        yield LoadingState((await _userSession.user()).content.payload);
        var response = await _userRepository.updateAccountInformation(
            event.username, event.email, event.password);
        if (response.status) {
          await _userSession.save(response);
          yield AccountInformationUpdateSuccessState(response.content.payload);
          userProfileBloc.dispatch(LoadProfileEvent());
        } else {
          yield ErrorState<UpdateAccountInformationEvent>(
              response.message, ErrorType.account, event);
          dispatch(LoadUserDataEvent());
        }
      }
      if (event is LoadUserDataEvent) {
        var user = await _userSession.user();
        yield UserLoadedState(user.content.payload);
      }
      if (event is UpdatePasswordEvent) {
        yield LoadingState((await _userSession.user()).content.payload);
        var response = await _userRepository.updatePassword(
            event.newPassword, event.confirmNewPassword, event.currentPassword);

        if (response.status) {
          await _userSession.clear();
          yield PasswordChangedSuccess();
        } else {
          yield ErrorState<UpdatePasswordEvent>(
              response.message, ErrorType.password, event);
          dispatch(LoadUserDataEvent());
        }
      }
      if (event is UpdateProfileAvatarEvent) {
        yield LoadingState((await _userSession.user()).content.payload);
        var response = await _userRepository.updateProfileImage(
            event.originalImage, event.croppedImage);
        if (response.status) {
          await _userSession.save(response);
          yield AvatarUpdateSuccess(response.content.payload);
          userProfileBloc.dispatch(LoadProfileEvent());
        } else {
          yield ErrorState<UpdateProfileAvatarEvent>(
              response.message, ErrorType.avatar, event);
          dispatch(LoadUserDataEvent());
        }
      }
      if (event is UpdatePersonalInformationEvent) {
        yield LoadingState((await _userSession.user()).content.payload);
        var response = await _userRepository.updatePersonalInformation(
            event.fullName, event.gender, event.address);
        if (response.status) {
          await _userSession.save(response);
          yield PersonalInformationUpdateSuccessState(response.content.payload);
          userProfileBloc.dispatch(LoadProfileEvent());
        } else {
          yield ErrorState<UpdatePersonalInformationEvent>(
              response.message, ErrorType.personal, event);
          dispatch(LoadUserDataEvent());
        }
      }
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          yield ErrorState(
              "Connection timedout, try again", ErrorType.none, null);
          break;
        case DioErrorType.SEND_TIMEOUT:
          yield ErrorState(
              "Connection timedout, try again", ErrorType.none, null);
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          yield ErrorState(
              "Connection timedout, try again", ErrorType.none, null);
          break;
        case DioErrorType.RESPONSE:
          yield ErrorState(
              "Server error, please try again or contact support team",
              ErrorType.none,
              null);
          break;
        case DioErrorType.CANCEL:
        case DioErrorType.DEFAULT:
          yield ErrorState(
              "Server error, please try again or contact support team",
              ErrorType.none,
              null);
          break;
      }
      dispatch(LoadUserDataEvent());
    } on SessionExpired catch (error) {
      await _userSession.clear();

      yield SessionExpiredState();
    } catch (error) {
      yield ErrorState("Unknown error: $error}", ErrorType.none, null);
      dispatch(LoadUserDataEvent());
    }
  }
}
