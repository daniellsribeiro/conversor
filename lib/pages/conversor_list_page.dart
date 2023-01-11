import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:conversor_monetario/main.dart';

class ConversorListPage extends StatefulWidget {
  ConversorListPage({Key? key}) : super(key: key);

  @override
  State<ConversorListPage> createState() => _ConversorListPageState();
}

class _ConversorListPageState extends State<ConversorListPage> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double? dolar;
  double? euro;

  void _ClearAll(){
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  void _realChanged(String text){
    if (text.isEmpty){
      _ClearAll();
      return;
    } else{
    double real = double.parse(text);
    dolarController.text = (real/dolar!).toStringAsFixed(2);
    euroController.text = (real/euro!).toStringAsFixed(2);
  }
  }
  void _dolarChanged(String text){
    if (text.isEmpty){
      _ClearAll();
      return;
    } else{
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar!).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar!/euro!).toStringAsFixed(2);
  }}
  void _euroChanged(String text){
    if (text.isEmpty){
      _ClearAll();
      return;
    } else{
    double euro = double.parse(text);
    realController.text = (euro * this.euro!).toStringAsFixed(2);
    dolarController.text = (euro * this.euro!/euro!).toStringAsFixed(2);
  }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          '\$ Conversor \$',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Carregando Dados...",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,),
                    textAlign: TextAlign.center,),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erro ao Carregar Dados :",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0),
                      textAlign: TextAlign.center,),
                  );
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                      child: Padding(
                        padding:EdgeInsets.all(16),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.monetization_on,
                                color: Colors.amberAccent,
                                size: 150,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              buildTextField("Reais", "R\$", realController, _realChanged),
                              const Divider(),
                              buildTextField("Dolares", "US\$", dolarController, _dolarChanged),
                              const Divider(),
                              buildTextField("Euros", "\u{20AC}", euroController, _euroChanged),
                            ],
                          ),
                        ),
                      )
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(
  String label, String prefix, TextEditingController c, Function f)
{ return TextFormField(
  controller: c,
  cursorColor: Colors.amberAccent,
  keyboardType: TextInputType.numberWithOptions(decimal:  true),
  style: TextStyle(
    color: Colors.amberAccent,
    fontSize: 30,
  ),
  decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: Colors.amberAccent),
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.amberAccent)),
    labelText: label,
    labelStyle: TextStyle(
      fontSize: 20,
      color: Colors.amberAccent,
    ),
    prefixText: prefix,
    prefixStyle:
    TextStyle(
        color: Colors.amberAccent, fontSize: 30),
  ),
  onChanged: (texto){f(texto);},
);
}
