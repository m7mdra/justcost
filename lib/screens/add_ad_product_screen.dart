import 'package:flutter/material.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/screens/ad.dart';
import 'package:justcost/screens/product_media_screen.dart';
import 'package:justcost/screens/ad_products_screen.dart';
import 'package:justcost/screens/postad/category_picker_screen.dart';
import 'package:justcost/util/tuple.dart';
import 'package:justcost/widget/ad_image_view.dart';
import 'package:justcost/widget/ad_video_view.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

import 'attribute/attribute_picker_screeen.dart';
import 'brand/brand_page.dart';

class AddAdProductScreen extends StatefulWidget {
  final AdditionType additionType;
  final AdProduct adProduct;

  const AddAdProductScreen({Key key, this.additionType, this.adProduct})
      : super(key: key);

  @override
  _AddAdProductScreenState createState() => _AddAdProductScreenState();
}

class _AddAdProductScreenState extends State<AddAdProductScreen> {
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
  List<Media> mediaList = [];

  @override
  void initState() {
    super.initState();
    if (isEditMode()) {
      var product = widget.adProduct;

      _nameController.text = product.name;
      _quantityController.text = product.quantity;
      _oldPriceController.text = product.oldPrice;
      _newPriceController.text = product.newPrice;
      _detailsController.text = product.details;
      _category = product.category;
      _brand = product.brand;
      attributeList = product.attributes;
      mediaList=product.mediaList;
    }
  }

  bool isEditMode() => widget.adProduct != null;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    _oldPriceController.dispose();
    _newPriceController.dispose();
    _detailsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hintStyle =
        Theme.of(context).textTheme.body1.copyWith(color: Colors.grey);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add product'),
      ),
      body: Form(
        key: _formKey,
        child: WillPopScope(
          onWillPop: () async {
            bool dismiss = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => RoundedAlertDialog(
                      title: Text('Discard data?'),
                      content: Text('Are you sure?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Yes'),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                        FlatButton(
                          child: Text('Cancel'),
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
                        'Product Media',
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
                        child: Text('Select'),
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
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {},
                  validator: (title) {
                    return title.isEmpty
                        ? "Product name Can not be Empty"
                        : null;
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      labelText: 'Product name',
                      errorBorder: InputBorder.none,
                      hintStyle: hintStyle),
                ),
                divider(),
                Visibility(
                  visible: widget.additionType != AdditionType.single,
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {},
                    validator: (quantity) {
                      if (widget.additionType == AdditionType.single)
                        return null;
                      return quantity.isEmpty
                          ? "quantity Can not be Empty"
                          : null;
                    },
                    maxLines: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        labelText: 'Quantity',
                        errorBorder: InputBorder.none,
                        hintStyle: hintStyle),
                  ),
                ),
                Visibility(
                  child: divider(),
                  visible: widget.additionType != AdditionType.single,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _oldPriceController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {},
                        validator: (oldPrice) {
                          return oldPrice.isEmpty
                              ? "old Price Can not be Empty"
                              : null;
                        },
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 8),
                            suffixText: 'AED',
                            labelText: 'Old Price',
                            hintStyle: hintStyle),
                      ),
                    ),
                    VerticalDivider(width: 1),
                    Expanded(
                      child: TextFormField(
                        controller: _newPriceController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {},
                        validator: (newPrice) {
                          return newPrice.isEmpty
                              ? "New Price Can not be Empty"
                              : null;
                        },
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 8),
                            labelText: 'New Price',
                            suffixText: 'AED',
                            hintStyle: hintStyle),
                      ),
                    ),
                  ],
                ),
                divider(),
                ListTile(
                  dense: true,
                  onTap: _onCategoryPickerClicked,
                  title: Text(
                    'Select Category',
                  ),
                  subtitle: Text(_category != null ? _category.name : ''),
                  trailing: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: _onCategoryPickerClicked,
                  ),
                ),
                divider(),
                ListTile(
                  dense: true,
                  title: Text(
                    'Select Brand',
                  ),
                  onTap: _onBrandPickerClicked,
                  subtitle: Text(_brand != null ? _brand.name : ''),
                  trailing: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: _onBrandPickerClicked,
                  ),
                ),
                divider(),
                ListTile(
                  dense: true,
                  title: Text(
                    'Select Attributes',
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
                divider(),
                TextFormField(
                  controller: _detailsController,
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  maxLength: 250,
                  validator: (text) {
                    if (text.isEmpty)
                      return "Details field can not be empty";
                    else
                      return null;
                  },
                  maxLengthEnforced: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      hintText: 'more details about the Product',
                      labelText: 'Product Details',
                      alignLabelWithHint: true,
                      hintStyle: hintStyle),
                ),
                divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          if (_category == null) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Select category first')));
                            return;
                          }
                          /* if (_brand == null) {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('Select Brand First')));
                            return;
                          }*/
                          var productName = _nameController.value.text;
                          var quantity = _quantityController.value.text;
                          var oldPrice = _oldPriceController.value.text;
                          var newPrice = _newPriceController.value.text;
                          var details = _detailsController.value.text;
                          if (double.parse(newPrice) > double.parse(oldPrice)) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    'new price field can not be more than old price field')));
                            return;
                          }
                          if (attributeList == null || attributeList.isEmpty) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Attributes can not be empty.')));
                            return;
                          }
                          var adProduct = AdProduct(
                              name: productName,
                              quantity: quantity,
                              oldPrice: oldPrice,
                              category: _category,
                              brand: _brand,
                              newPrice: newPrice,
                              mediaList: mediaList,
                              attributes: attributeList,
                              details: details);

                          Navigator.pop(context, adProduct);
                        }
                      },
                      child: Text('Done'),
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
        .push(MaterialPageRoute(builder: (context) => CategoryPickerScreen()));
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
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Select Category first')));
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
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Select Category first')));
    else {
      Brand brand = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BrandPage(
                categoryId: _parentCategory.id,
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
