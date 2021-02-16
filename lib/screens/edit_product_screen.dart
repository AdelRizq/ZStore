import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formState = GlobalKey<FormState>();

  Product _product = Product(
    id: null,
    price: 0,
    title: '',
    imageUrl: '',
    description: '',
    creatorId: '',
  );

  var _initValues = {
    'id': null,
    'title': '',
    'price': '',
    'imageUrl': '',
    'description': '',
  };

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      String productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        Product oldProduct = Provider.of<Products>(context).getById(productId);

        _initValues['id'] = oldProduct.id;
        _initValues['title'] = oldProduct.title;
        _initValues['price'] = oldProduct.price.toString();
        _initValues['description'] = oldProduct.description;
        _initValues['imageUrl'] = oldProduct.imageUrl;

        _product = Product(
          id: oldProduct.id,
          title: oldProduct.title,
          price: oldProduct.price,
          imageUrl: oldProduct.imageUrl,
          description: oldProduct.description,
          isFavorite: oldProduct.isFavorite,
          creatorId: oldProduct.creatorId,
        );

        _imageUrlController.text = _initValues['imageUrl'];
      }
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImageUrl);

    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.startsWith('http') ||
          _imageUrlController.text.startsWith('https')) {
        setState(() {});
      }
    }
  }

  Future<void> _saveForm() async {
    if (_formState.currentState.validate()) {
      _formState.currentState.save();
      setState(() => _isLoading = true);
      if (_product.id == null) {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_product);
        } catch (error) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error occured!',
          style: TextStyle(color: Theme.of(context).primaryColor),),
              content: Text('Something went wrong :(',
          style: TextStyle(color: Theme.of(context).primaryColor),),
              actions: [
                FlatButton(
                  child: Text('Okey',
          style: TextStyle(color: Theme.of(context).accentColor),),
                  onPressed: () => Navigator.of(ctx).pop(),
                )
              ],
            ),
          );
        }
      } else {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_product);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formState,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      validator: (title) {
                        if (title.isEmpty) {
                          return 'Please enter a title!';
                        }
                        return null;
                      },
                      onSaved: (title) {
                        _product = Product(
                          id: _product.id,
                          title: title,
                          price: _product.price,
                          description: _product.description,
                          imageUrl: _product.imageUrl,
                          isFavorite: _product.isFavorite,
                          creatorId: _product.creatorId,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      validator: (price) {
                        if (price.isEmpty) {
                          return 'Please enter a price!';
                        } else if (double.tryParse(price) == null) {
                          return 'Please enter a valid number!';
                        } else if (double.parse(price) <= 0) {
                          return 'Please enter a positive number (number > 0)!';
                        }
                        return null;
                      },
                      onSaved: (price) {
                        _product = Product(
                          id: _product.id,
                          title: _product.title,
                          price: double.parse(price),
                          description: _product.description,
                          imageUrl: _product.imageUrl,
                          isFavorite: _product.isFavorite,
                          creatorId: _product.creatorId,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (description) {
                        if (description.isEmpty) {
                          return 'Please enter a description!';
                        } else if (description.length <= 10) {
                          return 'Please enter a more than 10 characters description!';
                        }
                        return null;
                      },
                      onSaved: (description) {
                        _product = Product(
                          id: _product.id,
                          title: _product.title,
                          price: _product.price,
                          description: description,
                          imageUrl: _product.imageUrl,
                          creatorId: _product.creatorId,
                          isFavorite: _product.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 10,
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text("Enter an image url")
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            controller:
                                _imageUrlController, // cannot put initial value with controller at the same time
                            validator: (imageUrl) {
                              if (imageUrl.isEmpty) {
                                return 'Please enter an image url!';
                              } else if (!imageUrl.startsWith('http') &&
                                  !imageUrl.startsWith('https') &&
                                  !imageUrl.startsWith('data:')) {
                                return 'Please enter a valid URL';
                              }

                              return null;
                            },
                            onSaved: (imageUrl) {
                              _product = Product(
                                id: _product.id,
                                title: _product.title,
                                price: _product.price,
                                description: _product.description,
                                imageUrl: imageUrl,
                                isFavorite: _product.isFavorite,
                                creatorId: _product.creatorId,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
