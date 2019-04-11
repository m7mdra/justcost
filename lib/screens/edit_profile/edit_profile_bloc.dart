import 'package:bloc/bloc.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'edit_profile_events.dart';
import 'edit_profile_states.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UserSession _userSession;
  final UserRepository _userRepository;

  EditProfileBloc(this._userSession, this._userRepository);
  @override
  EditProfileState get initialState => EditProfileState();

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    try {
      if (event is UpdateAccountInformationEvent) {
        yield LoadingState();
        var response = await _userRepository.updateAccountInformation(
            event.username, event.email, event.password);
        await _userSession.saveUser(response);
        dispatch(LoadUserDataEvent());
      }
      if (event is LoadUserDataEvent) {
        var user = await _userSession.user();
        yield UserLoadedState(user.content.payload);
      }
      if (event is UpdatePasswordEvent) {
        yield LoadingState();
        var response = await _userRepository.updatePassword(
            event.newPassword, event.confirmNewPassword, event.currentPassword);
      }
      if (event is UpdateProfileAvatarEvent) {
        yield LoadingState();

        var response = await _userRepository.updateProfileImage(
            event.originalImage, event.croppedImage);
      }
      if (event is UpdatePersonalInformationEvent) {
        yield LoadingState();
      }
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          yield ErrorState("Connection timedout, try again");
          break;
        case DioErrorType.SEND_TIMEOUT:
          yield ErrorState("Connection timedout, try again");
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          yield ErrorState("Connection timedout, try again");
          break;
        case DioErrorType.RESPONSE:
          yield ErrorState(
              "Server error, please try again or contact support team");
          break;
        case DioErrorType.CANCEL:
          break;
        case DioErrorType.DEFAULT:
          yield ErrorState(
              "Server error, please try again or contact support team");
          break;
      }
    } on SessionExpired catch (error) {
      yield SessionExpiredState();
    } catch (error) {
      yield ErrorState("Unknown error: $error}");
    }
  }
}
