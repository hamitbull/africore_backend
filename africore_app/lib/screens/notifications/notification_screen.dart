import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {

  @override
  void initState() {
    super.initState();

    // Load notifications when screen opens
    Future.microtask(() {
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider =
    Provider.of<NotificationProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [

          IconButton(

            icon: const Icon(Icons.refresh),

            onPressed: () {
              provider.loadNotifications();
            },

          )

        ],
      ),

      body: provider.isLoading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : RefreshIndicator(

              onRefresh: provider.loadNotifications,

              child: provider.notifications.isEmpty

                  ? const Center(
                      child: Text(
                        "No notifications yet 🔔",
                      ),
                    )

                  : ListView.builder(

                      padding: const EdgeInsets.all(15),

                      itemCount:
                      provider.notifications.length,

                      itemBuilder: (context, index) {

                        final notif =
                        provider.notifications[index];

                        return AnimatedContainer(

                          duration:
                          const Duration(
                            milliseconds: 300,
                          ),

                          margin:
                          const EdgeInsets.only(
                            bottom: 12,
                          ),

                          padding:
                          const EdgeInsets.all(15),

                          decoration: BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                            BorderRadius.circular(15),

                            border: Border.all(
                              color: Colors.black12,
                            ),

                            boxShadow: [

                              BoxShadow(

                                color: Colors.black
                                    .withOpacity(0.05),

                                blurRadius: 10,

                                offset:
                                const Offset(0, 4),

                              )

                            ],
                          ),

                          child: Row(

                            children: [

                              // ICON
                              Container(

                                padding:
                                const EdgeInsets.all(10),

                                decoration: BoxDecoration(

                                  color:

                                  notif["type"] ==
                                      "payment"

                                      ? Colors.green.shade100

                                      : notif["type"] ==
                                      "security"

                                      ? Colors.red.shade100

                                      : Colors.blue.shade100,

                                  borderRadius:
                                  BorderRadius.circular(12),

                                ),

                                child: Icon(

                                  notif["type"] ==
                                      "payment"

                                      ? Icons.payments

                                      : notif["type"] ==
                                      "security"

                                      ? Icons.lock

                                      : Icons.notifications,

                                  color:

                                  notif["type"] ==
                                      "payment"

                                      ? Colors.green

                                      : notif["type"] ==
                                      "security"

                                      ? Colors.red

                                      : Colors.blue,

                                ),
                              ),

                              const SizedBox(width: 15),

                              // TEXT
                              Expanded(

                                child: Column(

                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [

                                    Text(

                                      notif["title"] ??
                                          "Notification",

                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),

                                    ),

                                    const SizedBox(height: 5),

                                    Text(

                                      notif["message"] ??
                                          "",

                                      style: TextStyle(
                                        color: Colors
                                            .grey.shade600,
                                      ),

                                    ),

                                  ],
                                ),
                              ),

                              // TIME
                              Text(

                                notif["time"] ?? "",

                                style: TextStyle(
                                  color:
                                  Colors.grey.shade500,
                                  fontSize: 12,
                                ),

                              ),

                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
