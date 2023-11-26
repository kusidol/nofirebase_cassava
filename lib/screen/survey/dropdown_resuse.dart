import 'package:flutter/material.dart';
import 'package:mun_bot/providers/dropdown_provider.dart';
import 'package:provider/provider.dart';
import 'package:mun_bot/providers/fieldService_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DropdownProvider>(
          create: (context) => DropdownProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'My App',
        home: dropdownReuseForService(name: 'Dropdown for field services'),
      ),
    );
  }
}

class dropdownReuseForService extends StatefulWidget {
  String? name;

  dropdownReuseForService({this.name, Key? key}) : super(key: key);

  @override
  State<dropdownReuseForService> createState() =>
      _dropdownReuseForServiceState();
}

class _dropdownReuseForServiceState extends State<dropdownReuseForService> {
  String selectedIndex = '';

  void fetchFirstData(BuildContext context) async {
    DropdownProvider provider =
        Provider.of<DropdownProvider>(context, listen: false);
    await provider.getFields();
    print("Check");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      fetchFirstData(context); // เรียกใช้ fetchFirstData ใน initState
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name ?? 'Dropdown for field services'),
      ),
      body: Consumer<DropdownProvider>(
        builder: (context, data, child) {
          List<Dropdown> dropdown = data.dropdown;
          return NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              print(notification.metrics.pixels);
              print(notification.metrics.maxScrollExtent);
              if (notification.metrics.pixels == 0) {
                // data.getFields();
              }
              if (notification.metrics.extentAfter == 0) {
                // fieldProvider.fetchDataPagination();
              }
              return true;
            },
            child: ListView.builder(
              itemCount: dropdown.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(dropdown[index].title.toString()),
                    onTap: () {
                      selectedIndex = dropdown[index].id.toString();
                      print("selectedIndex : ${selectedIndex}");
                      Navigator.pop(context, selectedIndex);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
