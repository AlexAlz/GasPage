import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gas_page/simple_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'login_card_container.dart';

class CombustibleScreen extends StatefulWidget {
  const CombustibleScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<CombustibleScreen> createState() => _CombustibleScreenState();
}

class _CombustibleScreenState extends State<CombustibleScreen> {
  String token = '';
  String refreshTokenValue = '';
  String endDateN = "";
  List<dynamic> viajesData = [];
  dynamic selectedTractor;
  List<String> tractorsList = [];
  bool isLoading = true;
  final apiKeyValue = 'R%2T@F3qAP2x5/y;hUB.kWAtGPG]3b';
  String jsonData = '';
  String vinOfInterest = "";
  bool dataLoaded = false;
  bool isCardVisible = false;

  @override
  void initState() {
    super.initState();
    final challenge = Challenge();
    challenge.fetchChallenge();
    fetchUnidades();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //loadUnits();
    fetchUnidades();
  }

  List<String> filteredTractorsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 191, 255),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CardContainer(
              child: SizedBox(
                height: 550,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset('images/fuel2.jpg'),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                filteredTractorsList = tractorsList
                                    .where((item) => item
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                                selectedTractor =
                                    filteredTractorsList.isNotEmpty
                                        ? filteredTractorsList[0]
                                        : null;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Filtrar',
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.search),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          isLoading
                              ? const CircularProgressIndicator()
                              : Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        icon: const Icon(
                                            Icons.arrow_drop_down_circle),
                                        iconDisabledColor: Colors.purple,
                                        iconEnabledColor: Colors.blue,
                                        iconSize: 20,
                                        isExpanded: true,
                                        value: selectedTractor,
                                        onChanged: (String? value) {
                                          setState(
                                              () => selectedTractor = value!);
                                        },
                                        items: filteredTractorsList
                                            .map((String item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(item),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade400),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await fetchDatas(apiKeyValue);
                                        setState(() {
                                          endDateN = DateTime.now().toString();
                                          sendToScania(endDateN);
                                          isCardVisible =
                                              true; // Mostrar el CardContainer cuando se presiona el botón
                                        });
                                      },
                                      child: const Text("Enviar"),
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            height: 40,
                          ),
                          Column(
                            children: [
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: isCardVisible ? 1.0 : 0.0,
                                child: CardContainer(
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Column(
                                        children: [
                                          const Text(
                                            "Los litros de combustible que debes recargar son:",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 50),
                                          Text(
                                            "${GlobalVariables.fuelConsumed} L",
                                            style: const TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.lightBlueAccent,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: isCardVisible ? 1.0 : 0.0,
                                child: CardContainer(
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Column(
                                        children: [
                                          const Text(
                                            "Los litros de urea que debes recargar son:",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 50),
                                          Text(
                                            "${GlobalVariables.ureaConsumed} L",
                                            style: const TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.lightBlueAccent,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchUnidades() async {
    try {
      const apiUrl =
          'https://sistematpilot.com/Apis/login/usuarios?tipo=Tractor';
      print(apiUrl);

      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Apikey': 'Y%MzJA:R}:G{=Q(U;wx6T',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.body;
        final parsedData = json.decode(jsonData) as List<dynamic>;

        final tractors =
            parsedData.map<String>((item) => item['eco'].toString()).toList();

        setState(() {
          viajesData = parsedData;
          tractorsList = tractors;
          filteredTractorsList = List.from(tractors);
          selectedTractor = tractors.isNotEmpty ? tractors[0] : null;
          isLoading = false;
          dataLoaded = true;
          if (parsedData.isNotEmpty) {
            GlobalVariables.numerocamion = parsedData[0]['eco'].toString();
            print("Camión ${GlobalVariables.numerocamion}");
          }
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al obtener los datos de los camiones: $error');
    }
  }

  Future<void> fetchDatas(String apiKeyValue) async {
    try {
      const apiUrl = 'https://sistematpilot.com/Apis/Attpilot/archivomatcombu';

      final headers = {'Content-Type': 'application/json'};

      final data = json.encode({
        'data': {"numerocamion": selectedTractor, "Apikey": apiKeyValue}
      });

      print(data);

      final response =
          await http.post(Uri.parse(apiUrl), headers: headers, body: data);
      if (response.statusCode == 200) {
        final jsonData = response.body;
        print(jsonData);
        final parsedData = json.decode(jsonData);

        final List<dynamic> results = parsedData as List<dynamic>;
        final Map<String, dynamic> firstResult = results.first;

        final marcaTrack = firstResult['marca'];
        GlobalVariables.marca = marcaTrack;

        final fechaSolicitud = firstResult['fechasolicitud'];

        final DateFormat scaniaDateFormat = DateFormat("yyyy-MM-ddHH:mm");
        final DateFormat samsaraDateFormat =
            DateFormat("yyyy-MM-ddTHH:mm:ss-06:00");
        GlobalVariables.vinOfInterest = firstResult['vin'];

        if (marcaTrack == 'SCANIA') {
          GlobalVariables.startDate = scaniaDateFormat
              .format(DateTime.parse(fechaSolicitud))
              .toString();
          endDateN =
              scaniaDateFormat.format(DateTime.parse(endDateN)).toString();
          //GlobalVariables.vinOfInterest = firstResult['vin'];

          print("Fecha de solicitud: ${GlobalVariables.startDate}");
          print("Fecha final  $endDateN");
          print("VIN: ${GlobalVariables.vinOfInterest}");
          print("La marca es: ${GlobalVariables.marca}");

          // Ejecutar las funciones correspondientes para SCANIA
          print("Es scania");
        } else {
          GlobalVariables.startDate = samsaraDateFormat
              .format(DateTime.parse(fechaSolicitud))
              .toString();
          // Aplicar el formato a endDate también
          //GlobalVariables.vinOfInterest = firstResult['vin'];

          print("Fecha de solicitud: ${GlobalVariables.startDate}");
          print("Fecha final   $endDateN");
          print("VIN: ${GlobalVariables.vinOfInterest}");
          print("La marca es: ${GlobalVariables.marca}");

          // Ejecutar las funciones correspondientes para otras marcas
          SamsaraAPI samsaraAPI = SamsaraAPI();
          await samsaraAPI.fetchDataSam(GlobalVariables.startDate, endDateN);

          // Esperar un breve período antes de continuar
          await Future.delayed(const Duration(seconds: 2));

          print("No es Scania");
        }
      } else {
        print('Request fallido: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al obtener los datos: $error');
    }
  }

  Future<void> sendToScania(String endDateN) async {
    try {
      final startDate = Uri.encodeComponent(GlobalVariables.startDate);

      final formatter = DateFormat('yyyy-MM-ddHH:mm');
      final endDate =
          Uri.encodeComponent(formatter.format(DateTime.parse(endDateN)));

      final vinOfInterest = Uri.encodeComponent(GlobalVariables.vinOfInterest);

      final apiUrl =
          'https://dataaccess.scania.com/cs/vehicle/reports/VehicleEvaluationReport/v2?startDate=$startDate&endDate=$endDate&vinOfInterest=$vinOfInterest';
      print(apiUrl);

      final headers = {
        'Accept':
            'application/vnd.fmsstandard.com.VehicleStatuses.v2.1+json; UTF-8',
        'Authorization': 'Bearer ${GlobalVariables.token}'
      };

      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = response.body;
        final parsedData = json.decode(jsonData);
        final vehicleList = parsedData['VehicleList'];
        final TotalFuelConsumptionApi = vehicleList[0]['TotalFuelConsumption'];
        final TotalUreaConsumptionApi =
            double.parse(vehicleList[0]['TotalFuelConsumption']);

        setState(() {
          GlobalVariables.fuelConsumed = TotalFuelConsumptionApi;
          GlobalVariables.ureaConsumed =
              (TotalUreaConsumptionApi * 0.05).toInt().toString();
        });

        print(TotalFuelConsumptionApi);
      } else {
        print('Request fallido: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al obtener los datos de los viajes: $error');
    }
  }
}

class Challenge {
  Future<void> fetchChallenge() async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
      'POST',
      Uri.parse('https://dataaccess.scania.com/auth/clientid2challenge/'),
    );
    request.bodyFields = {
      'clientId':
          'cH9sKpjE36zt1yhVLz204YzgTAeFoR793zXhK-kY1lo26qXhyQfgK36p2QVt-RmVsDxS5ckUC8_pMVq2riAbhA'
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      String challenge =
          result.substring(result.indexOf(':') + 2, result.length - 2);
      GlobalVariables.challengeValue = challenge;

      print("El challenge es: ${GlobalVariables.challengeValue}");

      String base64UrlEncode(List<int> arg) {
        return base64.encode(arg).replaceAll('+', '-').replaceAll('/', '_');
      }

      List<int> base64UrlDecode(String arg) {
        return base64.decode(base64.normalize(arg));
      }

      String createChallengeResponse(String secretKey, String challenge) {
        List<int> secretKeyArr = base64UrlDecode(secretKey);
        List<int> challengeArr = base64UrlDecode(challenge);
        List<int> challengeResponse =
            Hmac(sha256, secretKeyArr).convert(challengeArr).bytes;
        return base64UrlEncode(challengeResponse);
      }

      void saveChallengeResponse() {
        String secretKey =
            "zGfOUrm9n3SHZJXoCTAOtiwQ0VtiW8W5raJqA1GiZsCND04JVNKUbCRsX6kCLad0Eum5ogacW_ymzD13JUYJaw";
        String challenge = GlobalVariables.challengeValue;

        GlobalVariables.challengeResponse =
            createChallengeResponse(secretKey, challenge);

        GlobalVariables.challengeResponse = GlobalVariables.challengeResponse
            .substring(0, GlobalVariables.challengeResponse.length - 1);

        print("El challenge response es: ${GlobalVariables.challengeResponse}");
      }

      saveChallengeResponse();

      FirstToken firstToken = FirstToken();
      await firstToken.fetchFirstToken();
    }
  }
}

class FirstToken {
  Future<void> fetchFirstToken() async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST',
        Uri.parse('https://dataaccess.scania.com/auth/response2token/'));
    request.bodyFields = {
      'clientId':
          'cH9sKpjE36zt1yhVLz204YzgTAeFoR793zXhK-kY1lo26qXhyQfgK36p2QVt-RmVsDxS5ckUC8_pMVq2riAbhA',
      'Response': GlobalVariables.challengeResponse
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      Map<String, dynamic> data = json.decode(result);
      GlobalVariables.token = data['token'];
      GlobalVariables.refreshToken = data['refreshToken'];

      print("El token es: ${GlobalVariables.token}");
      print("El refreshToken es: ${GlobalVariables.refreshToken}");
    } else {
      print(response.reasonPhrase);
    }
  }
}

class SamsaraAPI {
  static const String apiUrl =
      'https://api.samsara.com/fleet/reports/vehicles/fuel-energy';
  static const String apiToken = 'samsara_api_xWHgaJe2rOI0WVMVq38chmzFZiWyIm';

  Future<void> fetchDataSam(String startDate, String endDate) async {
    endDate = DateFormat("yyyy-MM-ddTHH:mm:ss-06:00").format(DateTime.now());

    var url = '$apiUrl?startDate=$startDate&endDate=$endDate';
    print(url);

    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $apiToken',
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['data']['vehicleReports'] != null) {
        var filteredValue = data['data']['vehicleReports'];

        for (var vehicleReport in filteredValue) {
          var vehiculo = vehicleReport['vehicle']['name'];

          if (vehiculo == GlobalVariables.numerocamion) {
            final gas = vehicleReport['fuelConsumedMl'];
            final gasLitros = gas / 1000;
            final ureaLitros = gasLitros * 0.05;
            GlobalVariables.fuelConsumed = gasLitros.toString();
            GlobalVariables.ureaConsumed = ureaLitros.toString();
            print(
                'Vehículo: $vehiculo - Litros de combustible: $gasLitros - Litros de urea $ureaLitros');
          }
        }
      } else {
        print('No data found in the response');
      }
    } else {
      print(startDate);
      print(endDate);
      print('...');
    }
  }
}

class GlobalVariables {
  static String startDate = '';
  static String vinOfInterest = '';
  static String totalFuelConsumption = '';
  static String challengeValue = '';
  static String challengeResponse = '';
  static String token = '';
  static String refreshToken = '';
  static String marca = '';
  static String numerocamion = '';
  static String fuelConsumed = '';
  static String ureaConsumed = '';
}
