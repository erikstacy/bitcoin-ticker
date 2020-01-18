import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'services/networking.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'USD';
  String btcPrice = '';
  String ethPrice = '';
  String ltcPrice = '';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
        getNetworkData();
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        getNetworkData();
      },
      children: pickerItems,
    );
  }

  void getNetworkData() async {
    // Get the btc api data
    String btcUrl = 'https://apiv2.bitcoinaverage.com/indices/global/ticker/${cryptoList[0]}$selectedCurrency';
    NetworkHelper btcHelper = NetworkHelper(btcUrl);
    var btcData = await btcHelper.getData();
    double tempBtcPrice = btcData['last'];

    // Get the eth api data
    String ethUrl = 'https://apiv2.bitcoinaverage.com/indices/global/ticker/${cryptoList[1]}$selectedCurrency';
    NetworkHelper ethHelper = NetworkHelper(ethUrl);
    var ethData = await ethHelper.getData();
    double tempEthPrice = ethData['last'];

    // Get the ltc api data
    String ltcUrl = 'https://apiv2.bitcoinaverage.com/indices/global/ticker/${cryptoList[2]}$selectedCurrency';
    NetworkHelper ltcHelper = NetworkHelper(ltcUrl);
    var ltcData = await ltcHelper.getData();
    double tempLtcPrice = ltcData['last'];

    setState(() {
      btcPrice = tempBtcPrice.toString();
      ethPrice = tempEthPrice.toString();
      ltcPrice = tempLtcPrice.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getNetworkData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              children: <Widget>[
                CryptoCard(
                  currentPrice: btcPrice,
                  selectedCurrency: selectedCurrency,
                  selectedCrypto: cryptoList[0],
                ),
                CryptoCard(
                  currentPrice: ethPrice,
                  selectedCurrency: selectedCurrency,
                  selectedCrypto: cryptoList[1],
                ),
                CryptoCard(
                  currentPrice: ltcPrice,
                  selectedCurrency: selectedCurrency,
                  selectedCrypto: cryptoList[2],
                ),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker(): androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  
  CryptoCard({
    @required this.currentPrice,
    @required this.selectedCurrency,
    @required this.selectedCrypto,
  });

  final String currentPrice;
  final String selectedCurrency;
  final String selectedCrypto;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 60.0),
        child: Text(
          '1 $selectedCrypto = $currentPrice $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}