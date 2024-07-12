import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/business_layer/bloc/aqi/aqi_bloc.dart';
import 'package:weather_app/data_layer/data_model/air_pollution_param.dart';

class AirQualityScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const AirQualityScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  _AirQualityScreenState createState() => _AirQualityScreenState();
}

class _AirQualityScreenState extends State<AirQualityScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initiate data loading when screen initializes
    context.read<AQIBloc>().add(GetAQIData(
          longitude: widget.longitude,
          latitude: widget.latitude,
        ));
  }

  Future<void> _refresh() async {
    // Add your refresh logic here
    await Future.delayed(const Duration(seconds: 2), () {
      context.read<AQIBloc>().add(GetAQIData(
            longitude: widget.longitude,
            latitude: widget.latitude,
          ));
    });
  }

  String formatTimestamp(DateTime timestamp) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AQIBloc, AQIState>(
        listener: (context, state) {
          if (state is AQILoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Data Loaded Successfully!')),
            );
          } else if (state is AQIError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading data')),
            );
          }
        },
        child: BlocBuilder<AQIBloc, AQIState>(
          builder: (context, state) {
            if (state is AQILoading) {
              return Center(
                  child: CircularProgressIndicator(
                semanticsLabel: 'Fetching data...',
                backgroundColor: Colors.green,
                color: Colors.white,
              ));
            } else if (state is AQILoaded) {
              return _buildUI(state.airQualityModel);
            } else if (state is AQIError) {
              return Center(child: Text('Error loading data'));
            } else {
              return Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildUI(AirQualityModel airQuality) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Air Quality Index"),
              background: Container(color: airQuality.colorIndicator),
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    airQuality.aqi.toString(),
                    style: TextStyle(
                      fontSize: 80,
                      color: airQuality.colorIndicator,
                    ),
                  ),
                  Text(
                    airQuality.tagLine,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: airQuality.colorIndicator.withOpacity(
                          0.1), // Background color with some transparency
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildAirQualityInfo(
                            'PM2.5', airQuality.pm2_5.toString()),
                        _buildAirQualityInfo(
                            'PM10', airQuality.pm10.toString()),
                        _buildAirQualityInfo('SO2', airQuality.so2.toString()),
                        _buildAirQualityInfo('NO2', airQuality.no.toString()),
                        _buildAirQualityInfo('O3', airQuality.o3.toString()),
                        _buildAirQualityInfo('CO', airQuality.co.toString()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Last updated at : ${formatTimestamp(airQuality.timeStamp)}',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  const SizedBox(height: 500),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualityInfo(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ), // Adjust color as needed
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 14, color: Colors.black), // Adjust color as needed
        ),
      ],
    );
  }
}
