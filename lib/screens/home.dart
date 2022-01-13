import 'package:deart/globals.dart';
import 'package:deart/models/charge_state.dart';
import 'package:deart/models/vehicle.dart';
import 'package:deart/utils/auth_utils.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/utils/tesla_api.dart';
import 'package:deart/utils/unit_utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String commandStatus = 'N/A';
  String vehicleName = 'N/A';
  TeslaAPI api = TeslaAPI();
  ChargeState? chargeState;

  @override
  void initState() {
    initSettings();

    super.initState();
  }

  void initSettings() async {
    Globals.apiToken = await readStorageKey('token');
    if (Globals.apiToken != null) {
      String? vehilcleIdText = await readStorageKey('vehicleId');
      if (vehilcleIdText != null) {
        Globals.vehicleId = int.tryParse(vehilcleIdText);
      }

      // Load Vehicle Settings.
      await loadVehicle();

      await loadChargeState();

      // Wake up the car
      await api.wakeUp();
    } else {
      changeToken();
    }
  }

  Future loadVehicle() async {
    Vehicle vehicle = await api.getVehicle();
    Globals.vehicleId = vehicle.id;
    await writeStorageKey('vehicleId', vehicle.id.toString());

    setState(() {
      vehicleName = vehicle.displayName;
    });
  }

  Future loadChargeState() async {
    var result = await api.chargeState();
    if (result != null) {
      setState(() {
        chargeState = result;
      });
    }
  }

  void turnOnSentry() async {
    setState(() {
      commandStatus = 'Activating...';
    });
    bool success = await api.toggleSentry(true);

    setState(() {
      if (success) {
        commandStatus = 'Activated.';
      } else {
        commandStatus = 'Error Activating!';
      }
    });
  }

  void turnOffSentry() async {
    setState(() {
      commandStatus = 'Deactivating...';
    });

    bool success = await api.toggleSentry(false);

    setState(() {
      if (success) {
        commandStatus = 'Deactivated.';
      } else {
        commandStatus = 'Error Deactivating!';
      }
    });
  }

  void changeToken() {
    TextEditingController textEditingController = TextEditingController();

    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget okButton = TextButton(
      child: const Text("Ok"),
      onPressed: () async {
        String token = textEditingController.value.text;
        Globals.apiToken = token;
        await writeStorageKey('token', token);
        Navigator.of(context).pop();
      },
    );

    var dialog = AlertDialog(
      title: const Text('Paste your token here'),
      content: TextField(
        controller: textEditingController,
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    vehicleName,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text(
                      '${chargeState?.batteryLevel ?? 'N/A'}% (${mileToKM(chargeState?.batteryRange) ?? 'N/A'})km')
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sentry Mode State: ',
                ),
                Text(
                  commandStatus,
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                    onPressed: turnOnSentry,
                    child: const Text('Turn on Sentry')),
                ElevatedButton(
                    onPressed: turnOffSentry,
                    child: const Text('Turn off Sentry')),
                ElevatedButton(
                    onPressed: () => api.horn(),
                    child: const Text('Beep Beep')),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  // ElevatedButton(onPressed: login, child: const Text('Login')),
                  ElevatedButton(
                      onPressed: changeToken,
                      child: const Text('Change Token')),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
