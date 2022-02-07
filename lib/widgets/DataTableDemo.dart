import 'package:flutter/material.dart';
import 'Maziwa.dart';
import 'Services.dart';

class DataTableDemo extends StatefulWidget {
  DataTableDemo() : super();

  final String title = "Flutter Data Table";

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  late List<Maziwa> _maziwa;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController _nameController;
  late TextEditingController _litaController;
  late Maziwa _selectedMaziwa;
  late bool _isUpdating;
  late String _titleProgress;

  @override
  void initState() {
    super.initState();
    _maziwa = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _nameController = TextEditingController();
    _litaController = TextEditingController();
    _getMaziwa();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }


  _addMaziwa() {
    if (_nameController.text
        .trim()
        .isEmpty ||
        _litaController.text
            .trim()
            .isEmpty) {
      print("Empty fields");
      return;
    }
    _showProgress('Adding Maziwa...');
    Services.addMaziwa(_nameController.text, _litaController.text)
        .then((result) {
      if (result) {
        _getMaziwa();
      }
      _clearValues();
    });
  }

  _getMaziwa() {
    _showProgress('Loading Maziwa...');
    Services.getMaziwa().then((maziwa) {
      setState(() {
        _maziwa = maziwa;
      });
      _showProgress(widget.title);
      print("Length: ${maziwa.length}");
    });
  }

  _deleteMaziwa(Maziwa maziwa) {
    _showProgress('Deleting Maziwa...');
    Services.deleteMaziwa(maziwa.id).then((result) {
      if (result) {
        setState(() {
          _maziwa.remove(maziwa);
        });
        _getMaziwa();
      }
    });
  }

  _updateMaziwa(Maziwa maziwa) {
    _showProgress('Updating Maziwa...');
    Services.updateMaziwa(
        maziwa.id, _nameController.text, _litaController.text)
        .then((result) {
      if (result) {
        _getMaziwa();
        setState(() {
          _isUpdating = false;
        });
        _nameController.text = '';
        _litaController.text = '';
      }
    });
  }

  _setValues(Maziwa maziwa) {
    _nameController.text = maziwa.name;
    _litaController.text = maziwa.lita;
    setState(() {
      _isUpdating = true;
    });
  }

  _clearValues() {
    _nameController.text = '';
    _litaController.text = '';
  }

  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
                label: Text("ID"),
                numeric: false,
                tooltip: "This is the maziwa id"),
            DataColumn(
                label: Text(
                  "NAME",
                ),
                numeric: false,
                tooltip: "This is the full name"),
            DataColumn(
                label: Text("LITA"),
                numeric: false,
                tooltip: "Lita ngapi ya maziwa"),
            DataColumn(
                label: Text("DELETE"),
                numeric: false,
                tooltip: "Delete Action"),
          ],
          rows: _maziwa.map(
                (maziwa) =>
                DataRow(
                  cells: [
                    DataCell(
                      Text(maziwa.id),
                      onTap: () {
                        print("Tapped " + maziwa.name);
                        _setValues(maziwa);
                        _selectedMaziwa = maziwa;
                      },
                    ),
                    DataCell(
                      Text(
                        maziwa.name.toUpperCase(),
                      ),
                      onTap: () {
                        print("Tapped " + maziwa.name);
                        _setValues(maziwa);
                        _selectedMaziwa = maziwa;
                      },
                    ),
                    DataCell(
                      Text(
                        maziwa.lita.toUpperCase(),
                      ),
                      onTap: () {
                        print("Tapped " + maziwa.name);
                        _setValues(maziwa);
                        _selectedMaziwa = maziwa;
                      },
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteMaziwa(maziwa);
                        },
                      ),
                      onTap: () {
                        print("Tapped " + maziwa.name);
                      },
                    ),
                  ],
                ),
          )
              .toList(),
        ),
      ),
    );
  }

  showSnackBar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getMaziwa();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration.collapsed(
                  hintText: "Name",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _litaController,
                decoration: InputDecoration.collapsed(
                  hintText: "Lita",
                ),
              ),
            ),
            _isUpdating
                ? Row(
              children: <Widget>[
                OutlineButton(
                  child: Text('UPDATE'),
                  onPressed: () {
                    _updateMaziwa(_selectedMaziwa);
                  },
                ),
                OutlineButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState(() {
                      _isUpdating = false;
                    });
                    _clearValues();
                  },
                ),
              ],
            )
                : Container(),
            Expanded(
              child: _dataBody(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addMaziwa();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}