import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _formData = <String, Object>{};
  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;
        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _descriptionFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formData);
      Navigator.of(context).pop();
    } catch (err) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: Text('Erro ao salvar o produto. ${err.toString()}'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'))
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    final uri = url.toLowerCase();
    bool endWithFile = uri.endsWith('.png') ||
        uri.endsWith('.jpg') ||
        uri.endsWith('.webp') ||
        uri.endsWith('.jpeg');
    return isValidUrl && endWithFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de produto'),
        actions: [
          IconButton(
            onPressed: () => _submitForm(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _formData['name'] == null
                            ? ''
                            : _formData['name'].toString(),
                        decoration: const InputDecoration(labelText: 'Nome*'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                        },
                        onSaved: (name) => _formData['name'] = name ?? '',
                        validator: (_name) {
                          final name = _name ?? '';

                          if (name.trim().isEmpty) {
                            return 'O nome é obrigatório';
                          }
                          if (name.trim().length < 3) {
                            return 'O nome precisa de no mínimo 03 caracteres.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['price'] == null
                            ? ''
                            : _formData['price'].toString(),
                        decoration: const InputDecoration(labelText: 'Preço'),
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        focusNode: _priceFocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                        },
                        onSaved: (price) => _formData['price'] =
                            double.parse((price!.isNotEmpty ? price : '0.0')),
                        validator: (_price) {
                          final priceString = _price ?? '';
                          final price = double.tryParse(priceString) ?? -1;

                          if (price <= 0) {
                            return 'Informe um preço válido';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['description'] == null
                            ? ''
                            : _formData['description'].toString(),
                        decoration:
                            const InputDecoration(labelText: 'Descrição'),
                        // textInputAction: TextInputAction.next,
                        focusNode: _descriptionFocus,
                        keyboardType: TextInputType.multiline,
                        onSaved: (description) =>
                            _formData['description'] = description ?? '',
                        maxLines: 3,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_imageUrlFocus);
                        },
                        validator: (_description) {
                          final description = _description ?? '';

                          if (description.trim().isEmpty) {
                            return 'A descrição  é obrigatória';
                          }
                          if (description.trim().length < 10) {
                            return 'A descrição precisa de no mínimo 10 caracteres.';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Imagem'),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              focusNode: _imageUrlFocus,
                              controller: _imageUrlController,
                              onSaved: (imageUrl) =>
                                  _formData['imageUrl'] = imageUrl ?? '',
                              onFieldSubmitted: (_) => _submitForm(),
                              validator: (_imageUrl) {
                                final imageUrl = _imageUrl ?? '';
                                if (!isValidImageUrl(imageUrl)) {
                                  return 'Informe uma url válida!';
                                }

                                return null;
                              },
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(
                              top: 10,
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Informe a Url')
                                : Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
