import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _cepController = TextEditingController();

  String _valorRetorno = "";

  void _buscarCep() async {
    String cep = _cepController.text;

    var urlApi = Uri.parse("https://viacep.com.br/ws/$cep/json/");
    http.Response resposta = await http.get(urlApi);

    String endereco = "";

    if (resposta.statusCode == 200) {
      print('Código de Resposta: ${resposta.statusCode}');

      Map<String, dynamic> dadosCep = json.decode(resposta.body);

      endereco = "${dadosCep["logradouro"]}, ${dadosCep["bairro"]}, "
          "${dadosCep["localidade"]} - ${dadosCep["uf"]} ";
    } else {
      endereco = 'Cep informado incorretamente ou não encontrado.';
    }

    setState(() {
      _valorRetorno = endereco;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta de CEP"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'CEP'),
              ),
            ),
            Text(_valorRetorno)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buscarCep,
        backgroundColor: Color.fromARGB(255, 245, 245, 245),
        child: const Icon(Icons.search),
      ),
    );
  }
}
