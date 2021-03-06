import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//atalho para mudar de statelss para stateful => ctrl+.
class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  void _loadFormData(User user) {
    if (user != null) {
      _formData['id'] = user.id;
      _formData['name'] = user.name;
      _formData['email'] = user.email;
      _formData['avatarUrl'] = user.avatarUrl;
    }
  }

  void _launchURL() async {
    const url = 'https://pixabay.com/pt/images/search/avatar/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final User user = ModalRoute.of(context).settings.arguments;

    _loadFormData(user);
  }

  @override
  Widget build(BuildContext context) {
    //pegando os argumentos
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Usuário'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final isValid = _form.currentState.validate();

              if (isValid) {
                _form.currentState.save();

                Provider.of<Users>(context, listen: false).put(
                  User(
                    id: _formData['id'],
                    name: _formData['name'],
                    email: _formData['email'],
                    avatarUrl: _formData['avatarUrl'],
                  ),
                );

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                //instanciando um update
                initialValue: _formData['name'],
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  //.trim retira espaços
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome inválido';
                  }
                  if (value.trim().length <= 5) {
                    return 'Nome muito curto. Mímino 3 letras';
                  }

                  return null;
                },

                onSaved: (value) => _formData['name'] = value,
                //imprimi no console
                /*onSaved: (value) {
                  print(value);
                },*/
              ),
              TextFormField(
                initialValue: _formData['email'],
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
                onSaved: (value) => _formData['email'] = value,
              ),
              TextFormField(
                initialValue: _formData['avatarUrl'],
                decoration: InputDecoration(
                  labelText: 'Endereço do Avatar',
                ),
                onSaved: (value) => _formData['avatarUrl'] = value,
              ),
              FlatButton(
                onPressed: _launchURL,
                child: Text(
                  'Link para pegar Avatares: https://pixabay.com/pt/',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
