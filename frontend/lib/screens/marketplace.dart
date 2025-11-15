import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/job_card.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context)),
        title: const Text('Market Place'),
        actions: const [Padding(padding: EdgeInsets.only(right:16), child: Icon(Icons.search))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          JobCard(
            title: 'Mobile Nail Technician',
            company: 'Elite Events Co.',
            location: 'Kigali, Rwanda',
            salary: '\$100 - \$120',
            date: '5 days ago',
            reqs: ['Mobile setup', 'Vast Experience'],
          ),
          JobCard(
            title: 'Mobile Nail Technician',
            company: 'Elite Events Co.',
            location: 'Kigali, Rwanda',
            salary: '\$100 - \$120',
            date: '5 days ago',
            reqs: ['Mobile setup', 'Vast Experience'],
          ),
        ],
      ),
    );
  }
}
