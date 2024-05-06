import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:librariesplugin/librariesplugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = '';
  final _librariesPlugin = LibrariesPlugin();

  // Controller - UI
  final inputAddress = TextEditingController();
  final inputTTL = TextEditingController();
  var enableTTL = true;
  var executeEnable = true;

  // Initial Value
  final int _initTTL = -1;
  final String _initAddress = 'zing.vn';
  String actionValue = 'Ping';
  var actionValues = ['Ping', 'PageLoad', 'DnsLookup', 'PortScan'];

  @override
  void initState() {
    super.initState();
    initInput();
  }

  void initInput() {
    inputAddress.text = _initAddress;
    inputTTL.text = "$_initTTL";
    _result = "";
    executeEnable = true;
    setState(() {
      switch (actionValue) {
        case "Ping":
          enableTTL = true;
          break;
        default:
          enableTTL = false;
      }
    });
  }

  Future<void> pingState() async {
    // Start process  -------------------------------------------
    setState(() {
      executeEnable = false;
    });

    String pingResult;
    String address =
        (inputAddress.text.isNotEmpty) ? inputAddress.text : _initAddress;
    int ttl = (inputTTL.text.isNotEmpty) ? int.parse(inputTTL.text) : _initTTL;

    // Execute
    try {
      pingResult = await _librariesPlugin.getPingResult(address, ttl) ??
          'Invalid Ping Result';
    } on Exception {
      pingResult = 'Failed to get ping result.';
    }

    if (!mounted) return;

    // End process   -------------------------------------------
    setState(() {
      _result = pingResult;
      executeEnable = true;
    });
  }

  Future<void> pageLoadState() async {
    // Start process  -------------------------------------------
    setState(() {
      _result = "";
      executeEnable = false;
    });

    int time = 10;
    String pageLoadResult = "";
    String address =
        (inputAddress.text.isNotEmpty) ? inputAddress.text : _initAddress;

    // Execute
    while (time > 0) {
      try {
        pageLoadResult = await _librariesPlugin.getPageLoadResult(address) ??
            'Invalid PageLoad Result';
      } on Exception {
        pageLoadResult = 'Failed to get page load result.';
      }
      if (!mounted) return;
      setState(() {
        _result += pageLoadResult;
      });
      time--;
    }

    // End process   -------------------------------------------
    setState(() {
      executeEnable = true;
    });
  }

  Future<void> dnsLookupState() async {
    // Start process  -------------------------------------------
    setState(() {
      _result = "";
      executeEnable = false;
    });

    String dnsLookupResult = "";
    String address =
        (inputAddress.text.isNotEmpty) ? inputAddress.text : _initAddress;
    // Execute
    try {
      dnsLookupResult = await _librariesPlugin.getDnsLookupResult(address) ??
          'Invalid dnsLookup Result';
    } on Exception {
      dnsLookupResult = 'Failed to get dnsLookup result.';
    }

    if (!mounted) return;
    // End process   -------------------------------------------
    setState(() {
      _result += dnsLookupResult;
      executeEnable = true;
    });
  }

  Future<void> postScanState() async {
    // Start process  -------------------------------------------
    setState(() {
      _result = "";
      executeEnable = false;
    });

    String portScanResult = "";
    String address =
        (inputAddress.text.isNotEmpty) ? inputAddress.text : _initAddress;

    int start = 1;
    int end = 1023;
    // Execute
    while (start <= end) {
      try {
        portScanResult =
            await _librariesPlugin.getPortScanResult(start++, address) ??
                'Invalid PortScan Result';
      } on Exception {
        portScanResult = 'Failed to get PortScan result.';
      }

      setState(() {
        if (start % 10 == 1) _result = "$portScanResult\n";
        _result += "$portScanResult\n";
      });
    }

    if (!mounted) return;
    // End process   -------------------------------------------
    setState(() {
      executeEnable = true;
    });
  }

  void callState(String act) {
    switch (act) {
      case "Ping":
        pingState();
        break;
      case "PageLoad":
        pageLoadState();
        break;
      case "DnsLookup":
        dnsLookupState();
      case "PortScan":
        postScanState();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          // child: Text('Running on: $_platformVersion\n'),
          child: Column(
            children: [
              Builder(builder: (BuildContext context) {
                return IgnorePointer(
                  ignoring: !executeEnable,
                  child: Container(
                    decoration: BoxDecoration(
                      color: executeEnable ? Colors.white : Colors.grey[200],
                      // Background color
                      borderRadius: BorderRadius.circular(8.0),
                      // Rounded corners
                      border: Border.all(
                        color: executeEnable ? Colors.blue : Colors.grey[400]!,
                        // Border color
                        width: 2.0,
                      ),
                    ),
                    child: DropdownButton<String>(
                      // Initial Value
                      value: actionValue,
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 4.0, bottom: 4.0, right: 8.0),
                      // Down Arrow Icon
                      icon: Icon(Icons.keyboard_arrow_down,
                          color:
                              executeEnable ? Colors.blue : Colors.grey[400]),
                      // Arrow color
                      // Array list of items
                      items: actionValues.map((String items) {
                        return DropdownMenuItem<String>(
                          value: items,
                          child: Text(
                            items,
                            style: TextStyle(
                              color: executeEnable
                                  ? Colors.black
                                  : Colors.grey[600], // Text color
                            ),
                          ),
                        );
                      }).toList(),
                      // After selecting the desired option, it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          actionValue = newValue!;
                          initInput();
                        });
                      },
                      // DropdownButton styling
                      style: TextStyle(
                        color: executeEnable ? Colors.black : Colors.grey[600],
                        // DropdownButton text color
                        fontSize: 16.0,
                      ),
                      underline: Container(), // Hide the default underline
                    ),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter IP/Domain',
                  ),
                  controller: inputAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'TTL',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  enabled: enableTTL,
                  controller: inputTTL,
                ),
              ),
              const SizedBox(height: 30),
              Builder(builder: (BuildContext context) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        executeEnable ? Colors.blue : Colors.grey[400],
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  onPressed:
                      executeEnable ? () => callState(actionValue) : null,
                  child: const Text('Execute'),
                );
              }),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Text("$actionValue's Result\n$_result",
                    textAlign: TextAlign.center),
              )
            ],
          ),
        ),
      ),
    );
  }
}
