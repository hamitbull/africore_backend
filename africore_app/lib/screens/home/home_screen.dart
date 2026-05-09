import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("AFRICORE"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius:
              BorderRadius.circular(20),
            ),

            child: const Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  "Wallet Balance",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "₦0.00",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight:
                    FontWeight.bold,
                  ),
                )

              ],
            ),
          ),

          const SizedBox(height: 30),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,

            physics:
            const NeverScrollableScrollPhysics(),

            crossAxisSpacing: 15,
            mainAxisSpacing: 15,

            children: const [

              _HomeCard(
                title: "Transfer",
                icon: Icons.send,
              ),

              _HomeCard(
                title: "Mini Apps",
                icon: Icons.apps,
              ),

              _HomeCard(
                title: "Notifications",
                icon: Icons.notifications,
              ),

              _HomeCard(
                title: "KYC",
                icon: Icons.verified_user,
              ),

            ],
          )

        ],
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {

  final String title;
  final IconData icon;

  const _HomeCard({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color: Colors.black12,
        ),
      ),

      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(icon, size: 40),

          const SizedBox(height: 10),

          Text(title)

        ],
      ),
    );
  }
}
