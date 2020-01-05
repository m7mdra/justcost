import 'dart:core' as prefix0;
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/screens/attribute/attribute_picker_screeen.dart';
import 'package:justcost/screens/brand/brand_page.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/screens/myads/my_ads_screen.dart';
import 'package:justcost/screens/postad/ad.dart';
import 'package:justcost/screens/postad/addition_type.dart';
import 'package:justcost/screens/postad/product_media_screen.dart';
import 'package:justcost/screens/postad/category_picker_screen.dart';
import 'package:justcost/util/tuple.dart';
import 'package:justcost/widget/ad_image_view.dart';
import 'package:justcost/widget/ad_video_view.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/myad_edit/my_ads_edit_bloc.dart';
import 'package:justcost/model/media.dart' as media;

import '../../dependencies_provider.dart';

class AddAdProductScreen extends StatefulWidget {
  final AdditionType additionType;
  final AdProduct adProduct;
  final String from;
  final int adId;

  const AddAdProductScreen({Key key, this.additionType, this.adProduct ,this.from,this.adId})
      : super(key: key);

  @override
  _AddAdProductScreenState createState() => _AddAdProductScreenState();
}

class _AddAdProductScreenState extends State<AddAdProductScreen> {
  UpdateAdBloc _bloc;
  Category _category;
  Category _parentCategory;
  Brand _brand;
  List<Attribute> attributeList = List();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _oldPriceController = TextEditingController();
  TextEditingController _newPriceController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _adKeywordController = TextEditingController();
  FocusNode _adKeywordFocusNode = FocusNode();
  List<media.Media> mediaList = [];

  UserSession session = new UserSession();
  Future<String> language;
  String lanCode;

  @override
  void initState() {
    super.initState();

    language = session.getCurrentLanguage();
    language.then((onValue){
      prefix0.print('CATEGORY');
      setState(() {
        lanCode = onValue;
      });
    });

    _bloc =
        UpdateAdBloc(DependenciesProvider.provide(), DependenciesProvider.provide());

    if (isEditMode()) {
      var product = widget.adProduct;
      _nameController.text = product.name;
      _quantityController.text = product.quantity;
      _oldPriceController.text = product.oldPrice;
      _newPriceController.text = product.newPrice;
      _detailsController.text = product.details;
      _category = product.category;
      _adKeywordController.text = product.keyword;
      _brand = product.brand;
      attributeList =product.attributes;
      mediaList = product.mediaList;
    }
  }

  bool isEditMode() => widget.adProduct != null;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    _oldPriceController.dispose();
    _newPriceController.dispose();
    _detailsController.dispose();
    _adKeywordFocusNode.dispose();
    _adKeywordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hintStyle = Theme.of(context).textTheme.body1.copyWith(color: Colors.grey);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addProduct),
        leading: BackButton(),
      ),
      body: widget.from == 'edit'
          ? BlocBuilder(
            bloc: _bloc,
            builder: (BuildContext context, UpdateAdState state) {
              if (state is SuccessState)
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 80,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'تم إضافة المنتج للاعلان بنجاح',
    //                          AppLocalizations.of(context).adSubmitSuccessTitle,
                        style: Theme.of(context).textTheme.title,
                      ),
    //                        Text(AppLocalizations.of(context).adSubmitSuccessMessage),
                      Text('سوف يصلك اشعار اذا تم الموافقة علي إضافة الاعلان'),
                      const SizedBox(
                        height: 8,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyAdsScreen()));
                        },
                        child:
                        Text(MaterialLocalizations.of(context).okButtonLabel),
                      )
                    ],
                  ),
                );
              if (state is NetworkErrorState) {
                return Center(
                  child: NetworkErrorWidget(
                    onRetry: () {
                      _bloc.dispatch(AddProductEdit(
                            adId: widget.adId,
                            mediaList: mediaList,
                            name: _nameController.text,
                            oldPrice: _oldPriceController.text,
                            newPrice: _newPriceController.text,
                            categoryId: _category.id,
                            brandId: _brand.id,
                            attributeList: attributeList,
                            details: _detailsController.text
                      ));
                    },
                  ),
                );
              }
              if (state is ErrorState ||
                  state is FieldState) {
                return Center(
                  child: GeneralErrorWidget(
                    onRetry: () {
                      _bloc.dispatch(AddProductEdit(
                          adId: widget.adId,
                          mediaList: mediaList,
                          name: _nameController.text,
                          oldPrice: _oldPriceController.text,
                          newPrice: _newPriceController.text,
                          categoryId: _category.id,
                          brandId: _brand.id,
                          attributeList: attributeList,
                          details: _detailsController.text
                      ));
                    },
                  ),
                );
              }
              if (state is Loading)
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'جاري إضافة المنتج')
    //                            '${state.loading == Loading.ad ? AppLocalizations.of(context).postAdLoading : AppLocalizations.of(context).postProductsLoading}')
                    ],
                  ),
                );

              return Form(
                key: _formKey,
                child: WillPopScope(
                  onWillPop: () async {
                    bool dismiss = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => RoundedAlertDialog(
                          title: Text(AppLocalizations.of(context).discardData),
                          content: Text(AppLocalizations.of(context).areYouSure),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                  MaterialLocalizations.of(context).okButtonLabel),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                            ),
                            FlatButton(
                              child: Text(MaterialLocalizations.of(context)
                                  .cancelButtonLabel),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            ),
                          ],
                        ));
                    return Future.value(dismiss);
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).productsMedia,
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                              OutlineButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () async {
                                  var medias = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AdMediaScreen(
                                            mediaList: mediaList,
                                          )));
                                  print(medias);
                                  if (medias != null)
                                    setState(() {
                                      this.mediaList = medias;
                                    });
                                },
                                child: Text(AppLocalizations.of(context).select),
                                textTheme: ButtonTextTheme.normal,
                              )
                            ],
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.all(8),
                          child: SizedBox(
                            height: 180,
                            child: ListView.separated(
                              itemCount: mediaList.length,
                              padding: const EdgeInsets.all(8),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                if (mediaList[index].type == Type.Image)
                                  return AdImageView(
                                    showRemoveIcon: false,
                                    file: mediaList[index].file,
                                    size: Size(150, 150),
                                  );
                                else
                                  return AdVideoView(
                                    file: mediaList[index].file,
                                    showRemoveIcon: false,
                                    size: Size(150, 150),
                                  );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return VerticalDivider();
                              },
                            ),
                          ),
                        ),
                        Card(
                          child: TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () {},
                            validator: (title) {
                              return title.isEmpty
                                  ? AppLocalizations.of(context).productNameEmptyError
                                  : null;
                            },
                            maxLines: 1,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                labelText:
                                AppLocalizations.of(context).productNameField,
                                errorBorder: InputBorder.none,
                                hintStyle: hintStyle),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Card(
                                child: TextFormField(
                                  controller: _oldPriceController,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () {},
                                  validator: (oldPrice) {
                                    return oldPrice.isEmpty
                                        ? AppLocalizations.of(context)
                                        .oldPriceEmptyError
                                        : null;
                                  },
                                  keyboardType: TextInputType.phone,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                          left: 16, right: 16, top: 8, bottom: 8),
                                      suffixText: 'AED',
                                      labelText:
                                      AppLocalizations.of(context).oldPriceField,
                                      hintStyle: hintStyle),
                                ),
                              ),
                            ),
                            VerticalDivider(width: 1),
                            Expanded(
                              child: Card(
                                child: TextFormField(
                                  controller: _newPriceController,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () {},
                                  validator: (newPrice) {
                                    return newPrice.isEmpty
                                        ? AppLocalizations.of(context)
                                        .newPriceEmptyError
                                        : null;
                                  },
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                          left: 16, right: 16, top: 8, bottom: 8),
                                      labelText:
                                      AppLocalizations.of(context).newPriceField,
                                      suffixText: 'AED',
                                      hintStyle: hintStyle),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Card(
                          child: TextFormField(
                            focusNode: _adKeywordFocusNode,
                            textInputAction: TextInputAction.next,
                            validator: (keyword) {
                              return keyword.isEmpty
                                  ? AppLocalizations.of(context).keywordEmptyError
                                  : null;
                            },
                            maxLines: 1,
                            controller: _adKeywordController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 10, bottom: 10),
                                border: InputBorder.none,
                                helperText:
                                AppLocalizations.of(context).keywordFieldHelper,
                                hintText: AppLocalizations.of(context).keywordFieldHint,
                                labelText:
                                AppLocalizations.of(context).keywordFieldLabel,
                                hintStyle: hintStyle),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            dense: true,
                            onTap: _onCategoryPickerClicked,
                            title: Text(
                              AppLocalizations.of(context).selectCategory,
                            ),
                            subtitle: Text(_category != null ? _category.name : ''),
                            trailing: IconButton(
                              icon: Icon(Icons.keyboard_arrow_right),
                              onPressed: _onCategoryPickerClicked,
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            dense: true,
                            title: Text(
                              AppLocalizations.of(context).selectBrand,
                            ),
                            onTap: _onBrandPickerClicked,
                            subtitle: Text(_brand != null ? _brand.name : ''),
                            trailing: IconButton(
                              icon: Icon(Icons.keyboard_arrow_right),
                              onPressed: _onBrandPickerClicked,
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            dense: true,
                            title: Text(
                              AppLocalizations.of(context).selectAttributes,
                            ),
                            onTap: _onAttributePickerClicked,
                            subtitle: Wrap(
                              children: attributeList
                                  .map((attr) => Chip(
                                label: Text(attr.name),
                                onDeleted: () {
                                  attributeList.forEach((attribute) {
                                    if (attribute.id == attr.id) {
                                      attributeList.remove(attribute);
                                      setState(() {});
                                    }
                                  });
                                },
                              ))
                                  .toList(),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.keyboard_arrow_right),
                              onPressed: _onAttributePickerClicked,
                            ),
                          ),
                        ),
                        Card(
                          child: TextFormField(
                            controller: _detailsController,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            validator: (text) {
                              if (text.isEmpty)
                                return AppLocalizations.of(context)
                                    .productDetailsEmptyError;
                              else
                                return null;
                            },
                            maxLengthEnforced: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                hintText: AppLocalizations.of(context)
                                    .productDetailsFieldHint,
                                labelText: AppLocalizations.of(context)
                                    .productDetailsFieldLabel,
                                alignLabelWithHint: true,
                                hintStyle: hintStyle),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              onPressed: () {
//                        print(attributeList[0].name);
                                if (_formKey.currentState.validate()) {
                                  if (_category == null) {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text(AppLocalizations.of(context)
                                            .selectCategory)));
                                    return;
                                  }
                                  if (_brand == null) {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context).selectBrand)));
                                    return;
                                  }
                                  var productName = _nameController.value.text;
                                  var quantity = _quantityController.value.text;
                                  var oldPrice = _oldPriceController.value.text;
                                  var newPrice = _newPriceController.value.text;
                                  var details = _detailsController.value.text;
                                  var keyword = _adKeywordController.value.text;

                                  if (double.parse(newPrice) > double.parse(oldPrice)) {
                                    _scaffoldKey.currentState
                                      ..hideCurrentSnackBar(
                                          reason: SnackBarClosedReason.hide)
                                      ..showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context)
                                              .oldPriceLessThanNewPriceError)));
                                    return;
                                  }
                                  if (double.parse(newPrice) ==
                                      double.parse(oldPrice)) {
                                    _scaffoldKey.currentState
                                      ..hideCurrentSnackBar(
                                          reason: SnackBarClosedReason.hide)
                                      ..showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context)
                                              .newPriceEqualToNewPriceError)));
                                    return;
                                  }
//                          if (attributeList == null || attributeList.isEmpty) {
//                            _scaffoldKey.currentState
//                              ..hideCurrentSnackBar(
//                                  reason: SnackBarClosedReason.hide)
//                              ..showSnackBar(SnackBar(
//                                  content: Text(AppLocalizations.of(context)
//                                      .attributesEmptyError)));
//                            return;
//                          }
                                  if (mediaList.isEmpty) {
                                    _scaffoldKey.currentState
                                      ..hideCurrentSnackBar(
                                          reason: SnackBarClosedReason.hide)
                                      ..showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context)
                                              .mediaEmptyError)));
                                    return;
                                  }

                                  _bloc.dispatch(AddProductEdit(
                                      adId: widget.adId,
                                      mediaList: mediaList,
                                      name: _nameController.text,
                                      oldPrice: _oldPriceController.text,
                                      newPrice: _newPriceController.text,
                                      categoryId: _category.id,
                                      brandId: _brand.id,
                                      attributeList: attributeList,
                                      details: _detailsController.text
                                  ));
                                }
                              },
                              child: Text(AppLocalizations.of(context).submitButton),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )
          : Form(
        key: _formKey,
        child: WillPopScope(
          onWillPop: () async {
            bool dismiss = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => RoundedAlertDialog(
                  title: Text(AppLocalizations.of(context).discardData),
                  content: Text(AppLocalizations.of(context).areYouSure),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                          MaterialLocalizations.of(context).okButtonLabel),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                    FlatButton(
                      child: Text(MaterialLocalizations.of(context)
                          .cancelButtonLabel),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ],
                ));
            return Future.value(dismiss);
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).productsMedia,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      OutlineButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {
                          var medias = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdMediaScreen(
                                    mediaList: mediaList,
                                  )));
                          print(medias);
                          if (medias != null)
                            setState(() {
                              this.mediaList = medias;
                            });
                        },
                        child: Text(AppLocalizations.of(context).select),
                        textTheme: ButtonTextTheme.normal,
                      )
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(8),
                  child: SizedBox(
                    height: 180,
                    child: ListView.separated(
                      itemCount: mediaList.length,
                      padding: const EdgeInsets.all(8),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        if (mediaList[index].type == Type.Image)
                          return AdImageView(
                            showRemoveIcon: false,
                            file: mediaList[index].file,
                            size: Size(150, 150),
                          );
                        else
                          return AdVideoView(
                            file: mediaList[index].file,
                            showRemoveIcon: false,
                            size: Size(150, 150),
                          );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return VerticalDivider();
                      },
                    ),
                  ),
                ),
                Card(
                  child: TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {},
                    validator: (title) {
                      return title.isEmpty
                          ? AppLocalizations.of(context).productNameEmptyError
                          : null;
                    },
                    maxLines: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        labelText:
                        AppLocalizations.of(context).productNameField,
                        errorBorder: InputBorder.none,
                        hintStyle: hintStyle),
                  ),
                ),
                Visibility(
                  visible: widget.additionType != AdditionType.single,
                  child: Card(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {},
                      validator: (quantity) {
                        if (widget.additionType == AdditionType.single)
                          return null;
                        return quantity.isEmpty
                            ? AppLocalizations.of(context)
                            .productQuantityEmptyError
                            : null;
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
                          labelText:
                          AppLocalizations.of(context).productQuantity,
                          errorBorder: InputBorder.none,
                          hintStyle: hintStyle),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        child: TextFormField(
                          controller: _oldPriceController,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {},
                          validator: (oldPrice) {
                            return oldPrice.isEmpty
                                ? AppLocalizations.of(context)
                                .oldPriceEmptyError
                                : null;
                          },
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              suffixText: 'AED',
                              labelText:
                              AppLocalizations.of(context).oldPriceField,
                              hintStyle: hintStyle),
                        ),
                      ),
                    ),
                    VerticalDivider(width: 1),
                    Expanded(
                      child: Card(
                        child: TextFormField(
                          controller: _newPriceController,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {},
                          validator: (newPrice) {
                            return newPrice.isEmpty
                                ? AppLocalizations.of(context)
                                .newPriceEmptyError
                                : null;
                          },
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              labelText:
                              AppLocalizations.of(context).newPriceField,
                              suffixText: 'AED',
                              hintStyle: hintStyle),
                        ),
                      ),
                    ),
                  ],
                ),
//                Card(
//                  child: TextFormField(
//                    focusNode: _adKeywordFocusNode,
//                    textInputAction: TextInputAction.next,
//                    validator: (keyword) {
//                      return keyword.isEmpty
//                          ? AppLocalizations.of(context).keywordEmptyError
//                          : null;
//                    },
//                    maxLines: 1,
//                    controller: _adKeywordController,
//                    decoration: InputDecoration(
//                        contentPadding: const EdgeInsets.only(
//                            left: 16, right: 16, top: 10, bottom: 10),
//                        border: InputBorder.none,
//                        helperText:
//                        AppLocalizations.of(context).keywordFieldHelper,
//                        hintText: AppLocalizations.of(context).keywordFieldHint,
//                        labelText:
//                        AppLocalizations.of(context).keywordFieldLabel,
//                        hintStyle: hintStyle),
//                  ),
//                ),
                Card(
                  child: ListTile(
                    dense: true,
                    onTap: _onCategoryPickerClicked,
                    title: Text(
                      AppLocalizations.of(context).selectCategory,
                    ),
                    subtitle: Text(_category != null ? lanCode == 'ar' ? _category.arName : _category.name : ''),
                    trailing: IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: _onCategoryPickerClicked,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    dense: true,
                    title: Text(
                      AppLocalizations.of(context).selectBrand,
                    ),
                    onTap: _onBrandPickerClicked,
                    subtitle: Text(_brand != null ? _brand.name : ''),
                    trailing: IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: _onBrandPickerClicked,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    dense: true,
                    title: Text(
                      AppLocalizations.of(context).selectAttributes,
                    ),
                    onTap: _onAttributePickerClicked,
                    subtitle: Wrap(
                      children: attributeList
                          .map((attr) => Chip(
                        label: Text(attr.name),
                        onDeleted: () {
                          attributeList.forEach((attribute) {
                            if (attribute.id == attr.id) {
                              attributeList.remove(attribute);
                              setState(() {});
                            }
                          });
                        },
                      ))
                          .toList(),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: _onAttributePickerClicked,
                    ),
                  ),
                ),
                Card(
                  child: TextFormField(
                    controller: _detailsController,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    validator: (text) {
                      if (text.isEmpty)
                        return AppLocalizations.of(context)
                            .productDetailsEmptyError;
                      else
                        return null;
                    },
                    maxLengthEnforced: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        hintText: AppLocalizations.of(context)
                            .productDetailsFieldHint,
                        labelText: AppLocalizations.of(context)
                            .productDetailsFieldLabel,
                        alignLabelWithHint: true,
                        hintStyle: hintStyle),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
//                        print(attributeList[0].name);
                        if (_formKey.currentState.validate()) {
                          if (_category == null) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)
                                    .selectCategory)));
                            return;
                          }
                          if (_brand == null) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    AppLocalizations.of(context).selectBrand)));
                            return;
                          }
                          var productName = _nameController.value.text;
                          var quantity = _quantityController.value.text;
                          var oldPrice = _oldPriceController.value.text;
                          var newPrice = _newPriceController.value.text;
                          var details = _detailsController.value.text;
                          var keyword = _adKeywordController.value.text;

                          if (double.parse(newPrice) > double.parse(oldPrice)) {
                            _scaffoldKey.currentState
                              ..hideCurrentSnackBar(
                                  reason: SnackBarClosedReason.hide)
                              ..showSnackBar(SnackBar(
                                  content: Text(AppLocalizations.of(context)
                                      .oldPriceLessThanNewPriceError)));
                            return;
                          }
                          if (double.parse(newPrice) ==
                              double.parse(oldPrice)) {
                            _scaffoldKey.currentState
                              ..hideCurrentSnackBar(
                                  reason: SnackBarClosedReason.hide)
                              ..showSnackBar(SnackBar(
                                  content: Text(AppLocalizations.of(context)
                                      .newPriceEqualToNewPriceError)));
                            return;
                          }
//                          if (attributeList == null || attributeList.isEmpty) {
//                            _scaffoldKey.currentState
//                              ..hideCurrentSnackBar(
//                                  reason: SnackBarClosedReason.hide)
//                              ..showSnackBar(SnackBar(
//                                  content: Text(AppLocalizations.of(context)
//                                      .attributesEmptyError)));
//                            return;
//                          }
                          if (mediaList.isEmpty) {
                            _scaffoldKey.currentState
                              ..hideCurrentSnackBar(
                                  reason: SnackBarClosedReason.hide)
                              ..showSnackBar(SnackBar(
                                  content: Text(AppLocalizations.of(context)
                                      .mediaEmptyError)));
                            return;
                          }
                          print(_category.id);

                          var adProduct = AdProduct(
                            mediaList: mediaList,
                            name: productName,
                            oldPrice: oldPrice,
                            newPrice: newPrice,
                            keyword: keyword,
                            category: _category,
                            brand: _brand,
                            attributes: attributeList,
                            details: details,
                            quantity: quantity,
                          );

                          Navigator.pop(context, adProduct);
                        }
                      },
                      child: Text(AppLocalizations.of(context).submitButton),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _onCategoryPickerClicked() async {
    Tuple2 category = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CategoryPickerScreen(lanCode: lanCode,)));
    setState(() {
      _parentCategory = category.item1;

      if (category.item2 == null)
        this._category = category.item1;
      else
        this._category = category.item2;

    });
  }

  _onAttributePickerClicked() async {
    if (_category == null)
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).selectCategory)));
    else {
      var attrs = await Navigator.push(
          context,
          MaterialPageRoute<List<Attribute>>(
              builder: (context) => AttributePickerScreen(
                    categoryId: _category.id,
                    attributes: attributeList.toList(),
                  )));
      if (attrs != null) {
        attributeList = attrs;
      }
    }
  }

  _onBrandPickerClicked() async {
    if (_category == null)
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).selectCategory)));
    else {
      prefix0.print('Category ID');
      print(_category.id);
      Brand brand = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BrandPage(
                categoryId: _category.id,
              )));
      setState(() {
        this._brand = brand;
      });
    }
  }

  Divider divider() {
    return const Divider(
      height: 1,
      indent: 1,
    );
  }
}
