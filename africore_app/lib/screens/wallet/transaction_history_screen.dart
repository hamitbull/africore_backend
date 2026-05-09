import 'package:flutter/material.dart';

import '../../core/services/wallet_service.dart';

class TransactionHistoryScreen
    extends StatefulWidget {

  const TransactionHistoryScreen({
    super.key,
  });

  @override
  State<TransactionHistoryScreen>
  createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends State<TransactionHistoryScreen> {

  final WalletService walletService =
      WalletService();

  bool isLoading = true;

  List transactions = [];

  String selectedFilter = "all";

  // =============================
  // LOAD TRANSACTIONS
  // =============================
  Future<void> loadTransactions() async {

    try {

      final data =
      await walletService.getTransactions();

      setState(() {
        transactions = data;
      });

    } catch (e) {

      debugPrint(e.toString());

    } finally {

      setState(() {
        isLoading = false;
      });

    }
  }

  // =============================
  // FILTER TRANSACTIONS
  // =============================
  List filteredTransactions() {

    if (selectedFilter == "all") {
      return transactions;
    }

    return transactions.where((tx) {

      return tx["type"] ==
          selectedFilter;

    }).toList();
  }

  @override
  void initState() {
    super.initState();

    loadTransactions();
  }

  @override
  Widget build(BuildContext context) {

    final filtered =
    filteredTransactions();

    return Scaffold(

      appBar: AppBar(
        title:
        const Text("Transactions"),
      ),

      body: isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : Column(

        children: [

          // =============================
          // FILTERS
          // =============================
          Container(

            height: 60,

            padding:
            const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),

            child: ListView(

              scrollDirection:
              Axis.horizontal,

              children: [

                _FilterChip(
                  label: "All",
                  value: "all",
                  selected:
                  selectedFilter ==
                      "all",

                  onTap: () {

                    setState(() {
                      selectedFilter =
                      "all";
                    });

                  },
                ),

                _FilterChip(
                  label: "Credit",
                  value: "credit",
                  selected:
                  selectedFilter ==
                      "credit",

                  onTap: () {

                    setState(() {
                      selectedFilter =
                      "credit";
                    });

                  },
                ),

                _FilterChip(
                  label: "Debit",
                  value: "debit",
                  selected:
                  selectedFilter ==
                      "debit",

                  onTap: () {

                    setState(() {
                      selectedFilter =
                      "debit";
                    });

                  },
                ),

              ],
            ),
          ),

          // =============================
          // TRANSACTION LIST
          // =============================
          Expanded(

            child: filtered.isEmpty

                ? const Center(
              child: Text(
                "No transactions found",
              ),
            )

                : RefreshIndicator(

              onRefresh:
              loadTransactions,

              child: ListView.builder(

                padding:
                const EdgeInsets.all(15),

                itemCount:
                filtered.length,

                itemBuilder:
                    (context, index) {

                  final tx =
                  filtered[index];

                  final isCredit =
                      tx["type"] ==
                          "credit";

                  return Container(

                    margin:
                    const EdgeInsets.only(
                      bottom: 15,
                    ),

                    padding:
                    const EdgeInsets.all(
                      15,
                    ),

                    decoration:
                    BoxDecoration(

                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),

                      color:
                      Colors.white,

                      boxShadow: [

                        BoxShadow(
                          color: Colors.black
                              .withOpacity(
                            0.03,
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
                            12,
                          ),

                          decoration:
                          BoxDecoration(

                            color:

                            isCredit

                                ? Colors.green
                                .shade100

                                : Colors.red
                                .shade100,

                            borderRadius:
                            BorderRadius.circular(
                              15,
                            ),
                          ),

                          child: Icon(

                            isCredit

                                ? Icons
                                .arrow_downward

                                : Icons
                                .arrow_upward,

                            color:

                            isCredit

                                ? Colors.green

                                : Colors.red,
                          ),
                        ),

                        const SizedBox(
                          width: 15,
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

                                tx["description"] ??
                                    "Transaction",

                                style:
                                const TextStyle(

                                  fontWeight:
                                  FontWeight
                                      .bold,

                                  fontSize:
                                  16,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              Text(

                                tx["createdAt"] ??
                                    "",

                                style:
                                TextStyle(

                                  color: Colors
                                      .grey
                                      .shade600,

                                  fontSize:
                                  13,
                                ),
                              )

                            ],
                          ),
                        ),

                        // =============================
                        // AMOUNT
                        // =============================
                        Text(

                          "${isCredit ? "+" : "-"} ₦${tx["amount"]}",

                          style: TextStyle(

                            color:

                            isCredit

                                ? Colors.green

                                : Colors.red,

                            fontWeight:
                            FontWeight.bold,

                            fontSize: 16,
                          ),
                        )

                      ],
                    ),
                  );
                },
              ),
            ),
          )

        ],
      ),
    );
  }
}

// =============================
// FILTER CHIP
// =============================
class _FilterChip
    extends StatelessWidget {

  final String label;

  final String value;

  final bool selected;

  final VoidCallback onTap;

  const _FilterChip({

    required this.label,

    required this.value,

    required this.selected,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        margin:
        const EdgeInsets.only(
          right: 10,
        ),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),

        decoration: BoxDecoration(

          color:

          selected

              ? Colors.black

              : Colors.grey.shade200,

          borderRadius:
          BorderRadius.circular(30),

        ),

        child: Text(

          label,

          style: TextStyle(

            color:

            selected

                ? Colors.white

                : Colors.black,

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
