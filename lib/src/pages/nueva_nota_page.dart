import 'package:flutter/material.dart';
import 'package:notas/src/blocs/blocs.dart';
import 'package:notas/src/models/nota_model.dart';

class NuevaNotaPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as NotasBloc;
    NotaModel notaModel = NotaModel(active: 1, parentid: args.idBloc);
    // print(args.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nota'),
        centerTitle: true,
      ),
      body: Forma(formKey: formKey, notaModel: notaModel),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState == null) {
            final snackBar = SnackBar(
                content: Text('No se pueden guardar elementos vacios.'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          if (!formKey.currentState!.validate()) return;

          formKey.currentState!.save();
          _submit(context, notaModel, args);
        },
        child: Icon(Icons.save_rounded),
      ),
    );
  }

  _submit(BuildContext context, NotaModel notaModel, NotasBloc bloc) async {
    bloc.store(notaModel);
    Navigator.pop(context);
  }
}

class Forma extends StatelessWidget {
  const Forma({
    Key? key,
    required this.formKey,
    required this.notaModel,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final NotaModel notaModel;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Escriba un titulo para la nota',
                  labelText: 'Titulo',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              validator: (value) {
                if (value!.length < 3) {
                  return 'Debe ingresar un titulo valido.';
                }
                return null;
              },
              onSaved: (value) {
                notaModel.title = value;
              },
            ),
            TextFormField(
              maxLines: null,
              decoration: InputDecoration(
                  hintText: 'Escriba una descripción para la nota (opcional)',
                  labelText: 'Descripción',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              validator: (value) {
                // if(value!.length < 3){
                //   return 'Debe ingresar una descripción valida.';
                // }
                return null;
              },
              onSaved: (value) {
                notaModel.body = value;
              },
            ),
          ],
        ));
  }
}
