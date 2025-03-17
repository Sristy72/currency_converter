import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CurrencyConvert extends StatefulWidget {
  const CurrencyConvert({super.key});

  @override
  State<CurrencyConvert> createState() => _CurrencyConvertState();
}

class _CurrencyConvertState extends State<CurrencyConvert> {
  //FetchCurrency fetchCurrency = FetchCurrency();
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  double rate = 0.0;
  double total = 0.0;
  TextEditingController _amountController = TextEditingController();
  List<String> currencies = [];

  // Future<void> _fetchCurrencies() async{
  //   final currencyAndRate = await fetchCurrency.fetchCurrenciesAndRates(fromCurrency);
  //   setState(() {
  //     currencies = (currencyAndRate['rates'] as Map<String, dynamic>).keys.toList();
  //     rate = currencyAndRate['rates'][toCurrency];
  //   });
  // }

  Future<void> _fetchCurrencies() async {
    final url = 'https://api.exchangerate-api.com/v4/latest/$fromCurrency';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        currencies = data["rates"].keys.toList();
      });
    } else {
      throw Exception("Failed to load currencies");
    }
  }

  Future<void> _fetchRate() async {
    final url = 'https://api.exchangerate-api.com/v4/latest/$fromCurrency';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    setState(() {
      rate = data['rates'][toCurrency];
    });
  }

  void _swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      _fetchRate();
    });}

  _totalAmount(){
    if(_amountController.text != ''){
      setState(() {
        double amount = double.parse(_amountController.text);
        total = amount * rate;
      });

    }
  }

  @override
  void initState() {
    _fetchCurrencies();
    _fetchRate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Currency Converter",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: Image.asset(
                    "assets/images/currency.png",
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
                child: TextField(
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.white),
                  ),

                  // onChanged: (value) {
                  //   if (value != '') {
                  //     setState(() {
                  //       double amount = double.parse(value);
                  //       total = amount * rate;
                  //     });
                  //   }
                  // },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: DropdownButton<String>(
                        value: fromCurrency,
                        isExpanded: true,
                        //style: TextStyle(color: Colors.white),
                        items: currencies.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            fromCurrency = newValue!;
                            _fetchCurrencies();
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _swapCurrencies();
                      },
                      icon: Icon(Icons.swap_horiz, color: Colors.white),
                    ),

                    SizedBox(
                      width: 100,
                      child: DropdownButton<String>(
                        value: toCurrency,
                        isExpanded: true,
                        //style: TextStyle(color: Colors.white),
                        items: currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            toCurrency = newValue!;
                            _fetchRate();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Text('Rate $rate',
                style: TextStyle(color: Colors.white, fontSize: 20,),),

              SizedBox(height: 20,),

              ElevatedButton(onPressed: (){_totalAmount();}, child: Text('convert')),

              SizedBox(height: 20,),
              Text('${total.toStringAsFixed(3)}', style: TextStyle(color: Colors.white, fontSize: 20,),),
            ],
          ),
        ),
      ),
    );
  }
}
