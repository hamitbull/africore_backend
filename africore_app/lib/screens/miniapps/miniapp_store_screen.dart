import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MiniAppStoreScreen
    extends StatefulWidget {

  const MiniAppStoreScreen({
    super.key,
  });

  @override
  State<MiniAppStoreScreen>
  createState() =>
      _MiniAppStoreScreenState();
}

class _MiniAppStoreScreenState
    extends State<MiniAppStoreScreen> {

  List miniApps = [

    {
      "name": "AfroPay",
      "description":
      "Digital payment system",

      "icon":
      Icons.account_balance_wallet,

      "url":
      "https://example.com"
    },

    {
      "name": "AfroRide",
      "description":
      "Ride hailing platform",

      "icon":
      Icons.directions_car,

      "url":
      "https://example.com"
    },

    {
      "name": "AfroMarket",
      "description":
      "African e-commerce",

      "icon":
      Icons.shopping_cart,

      "url":
      "https://example.com"
    },

    {
      "name": "AfroChat",
      "description":
      "Messaging ecosystem",

      "icon":
      Icons.chat,

      "url":
      "https://example.com"
    }

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Mini App Store",
        ),
      ),

      body: ListView.builder(

        padding:
        const EdgeInsets.all(20),

        itemCount:
        miniApps.length,

        itemBuilder:
            (context, index) {

          final app =
          miniApps[index];

          return GestureDetector(

            onTap: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      MiniAppWebViewScreen(

                        title:
                        app["name"],

                        url:
                        app["url"],
                      ),
                ),
              );
            },

            child: Container(

              margin:
              const EdgeInsets.only(
                bottom: 20,
              ),

              padding:
              const EdgeInsets.all(18),

              decoration:
              BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  20,
                ),

                boxShadow: [

                  BoxShadow(

                    color:
                    Colors.black
                        .withOpacity(
                      0.04,
                    ),

                    blurRadius: 10,

                    offset:
                    const Offset(
                      0,
                      4,
                    ),
                  )

                ],
              ),

              child: Row(

                children: [

                  // =============================
                  // ICON
                  // =============================
                  Container(

                    padding:
                    const EdgeInsets.all(
                      16,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.black,

                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),

                    child: Icon(

                      app["icon"],

                      color:
                      Colors.white,

                      size: 30,
                    ),
                  ),

                  const SizedBox(
                    width: 18,
                  ),

                  // =============================
                  // DETAILS
                  // =============================
                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(

                          app["name"],

                          style:
                          const TextStyle(

                            fontSize: 20,

                            fontWeight:
                            FontWeight
                                .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        Text(
                          app["description"],
                        )

                      ],
                    ),
                  ),

                  // =============================
                  // OPEN BUTTON
                  // =============================
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// =============================
// MINI APP WEBVIEW
// =============================
class MiniAppWebViewScreen
    extends StatefulWidget {

  final String title;

  final String url;

  const MiniAppWebViewScreen({

    super.key,

    required this.title,

    required this.url,
  });

  @override
  State<MiniAppWebViewScreen>
  createState() =>
      _MiniAppWebViewScreenState();
}

class _MiniAppWebViewScreenState
    extends State<MiniAppWebViewScreen> {

  late final WebViewController
  controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()

      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )

      ..setNavigationDelegate(

        NavigationDelegate(

          onPageFinished: (_) {

            setState(() {
              isLoading = false;
            });

          },
        ),
      )

      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Stack(

        children: [

          WebViewWidget(
            controller: controller,
          ),

          if (isLoading)

            const Center(
              child:
              CircularProgressIndicator(),
            )

        ],
      ),
    );
  }
}
