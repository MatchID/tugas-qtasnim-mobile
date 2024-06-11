import 'package:flutter/material.dart';
import 'package:test_qtasnim/models/comparation.dart';
import 'package:test_qtasnim/utility/api_provider.dart';

class ComparationPage extends StatefulWidget {
  @override
  _ComparationPageState createState() => _ComparationPageState();
}

class _ComparationPageState extends State<ComparationPage> {
  List<Comparation> _comparations = [];
  bool _isLoading = true;
  bool _isDescending = true;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchComparations();
  }

  Future<void> _fetchComparations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiProvider = ApiProvider();
      final order = _isDescending ? 'desc' : 'asc';
      final startDate = _startDate != null ? _startDate!.toString() : '';
      final endDate = _endDate != null ? _endDate!.toString() : '';
      print("CEKDATA =>>> " +
          'order=$order&startDate=${startDate.split(" ")[0]}&endDate=${endDate.split(" ")[0]}');
      final response = await apiProvider.get(
          url: '/api/transaksi/compare',
          body:
              'order=$order&startDate=${startDate.split(" ")[0]}&endDate=${endDate.split(" ")[0]}');
      final List<Comparation> comparations = comparationFromJson(response);
      setState(() {
        _comparations = comparations;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching comparations: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data. Please try again later.'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleSortOrder() {
    setState(() {
      _isDescending = !_isDescending;
    });
    _fetchComparations();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comparation Page'),
        actions: [
          IconButton(
            icon:
                Icon(_isDescending ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: _toggleSortOrder,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _startDate != null
                            ? '${_startDate!.day}-${_startDate!.month}-${_startDate!.year}'
                            : 'Select Date',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _endDate != null
                            ? '${_endDate!.day}-${_endDate!.month}-${_endDate!.year}'
                            : 'Select Date',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _fetchComparations,
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _comparations.isEmpty
                  ? Center(child: Text('No Data Available'))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _comparations.length,
                        itemBuilder: (context, index) {
                          final comparation = _comparations[index];
                          return ComparationItem(comparation: comparation);
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

class ComparationItem extends StatelessWidget {
  final Comparation comparation;

  const ComparationItem({
    required this.comparation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        title: Text(comparation.jenisBarang),
        subtitle: Text('Total Terjual: ${comparation.totalTerjual}'),
      ),
    );
  }
}
