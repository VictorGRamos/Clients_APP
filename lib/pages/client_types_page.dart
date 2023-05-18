import 'package:client_control/models/client_type.dart';
import 'package:flutter/material.dart';

import '../components/hamburger_menu.dart';
import '../components/icon_picker.dart';

class ClientTypesPage extends StatefulWidget {
  const ClientTypesPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ClientTypesPage> createState() => _ClientTypesPageState();
}

class _ClientTypesPageState extends State<ClientTypesPage> {

  List<ClientType> types = [
    ClientType(name: 'Platinum', icon: Icons.credit_card),
    ClientType(name: 'Golden', icon: Icons.card_membership),
    ClientType(name: 'Titanium', icon: Icons.credit_score),
    ClientType(name: 'Diamond', icon: Icons.diamond),
  ];

  IconData? selectedIcon;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const HamburgerMenu(),
      body: ListView.builder(
        itemCount: types.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            child: ListTile(
              leading: Icon(types[index].icon),
              title: Text(types[index].name),
              iconColor: Colors.deepOrange,
            ),
            onDismissed: (direction) {
              setState(() {
                types.removeAt(index);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: (){createType(context);},
        tooltip: 'Add Tipo',
        child: const Icon(Icons.add),
      ),
    );
  }

  void createType(context) {
    TextEditingController nomeInput = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Cadastrar tipo'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: nomeInput,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      icon: Icon(Icons.account_box),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    return Column(children: [
                      const Padding(padding: EdgeInsets.all(5)),
                      selectedIcon != null ? Icon(selectedIcon, color: Colors.deepOrange) : const Text('Selecione um ícone'),
                      const Padding(padding: EdgeInsets.all(5)),
                      SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                            onPressed: () async {
                              final IconData? result = await showIconPicker(context: context, defalutIcon: selectedIcon);
                              setState(() {
                                selectedIcon = result;
                              });
                            },
                            child: const Text('Selecionar icone')
                        ),
                      ),
                    ]);
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Salvar"),
              onPressed: () {
                selectedIcon ??= Icons.credit_score;
                types.add(ClientType(name: nomeInput.text, icon: selectedIcon));
                selectedIcon = null;
                setState(() {});
                Navigator.pop(context);
              }
            ),
            TextButton(
              child: const Text("Calcelar"),
              onPressed: () async {
                selectedIcon = null;
                Navigator.pop(context);
              }
            )
          ],
        );
      }
    );
  }
}
