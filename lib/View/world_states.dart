import 'package:covid19/Model/WorldStateModel.dart';
import 'package:covid19/Services/states_services.dart';
import 'package:covid19/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStateScreen extends StatefulWidget {
  const WorldStateScreen({Key? key}) : super(key: key);

  @override
  State<WorldStateScreen> createState() => _WorldStateScreenState();
}

class _WorldStateScreenState extends State<WorldStateScreen> with TickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this
  )..repeat();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  
  final colorList = <Color> [
    Color(0xff4285f4),
    Color(0xff1aa260),
    Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .01,),
              FutureBuilder(
                future: statesServices.fetchWorldStatesRecord(),
                  builder: (context,AsyncSnapshot<WorldStateModel> snapshot){
                if(!snapshot.hasData){
                  return Expanded(
                    flex: 1,
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50,
                      controller: _controller,
                    ),
                  );
                }else{
                  return Column(
                    children: [
                      PieChart(
                        dataMap: {
                          "Total" : double.parse(snapshot.data!.cases!.toString()),
                          "Recovered" : double.parse(snapshot.data!.recovered.toString()),
                          "Deaths" : double.parse(snapshot.data!.deaths.toString()),
                        },
                        chartValuesOptions: ChartValuesOptions(
                          showChartValuesInPercentage: true
                        ),
                        chartRadius: MediaQuery.of(context).size.width/3.2,
                        legendOptions: LegendOptions(
                            legendPosition: LegendPosition.left
                        ),
                        animationDuration: Duration(milliseconds: 1200),
                        chartType: ChartType.ring,
                        colorList: colorList,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*.06),
                        child: Card(
                          child: Column(
                            children: [
                              ReuseableRow(title: 'Total', value: snapshot.data!.cases.toString()),
                              ReuseableRow(title: 'Deaths', value: snapshot.data!.deaths.toString()),
                              ReuseableRow(title: 'Recovered', value: snapshot.data!.recovered.toString()),
                              ReuseableRow(title: 'Active', value: snapshot.data!.active.toString()),
                              ReuseableRow(title: 'Critical', value: snapshot.data!.critical.toString()),
                              ReuseableRow(title: 'Today Deaths', value: snapshot.data!.todayDeaths.toString()),
                              ReuseableRow(title: 'Today Recovered', value: snapshot.data!.todayRecovered.toString()),
                              ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap : (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CountriesList()));
                    },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xff1aa260),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text('Track Country'),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  String title, value;
  ReuseableRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(height: 5,),
          Divider()
        ],
      ),
    );
  }
}
