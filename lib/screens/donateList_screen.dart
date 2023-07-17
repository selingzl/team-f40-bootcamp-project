import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonateListPage extends StatelessWidget {
  const DonateListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(185, 187, 223, 1),
                  Color.fromRGBO(223, 244, 243, 1),
                  Color.fromRGBO(185, 187, 223, 1),
                ],
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context)
                    .padding
                    .top, // Status bar yüksekliği kadar boşluk bırakır
              ),
              const SizedBox(height: 55),
              Image.asset(
                'lib/assets/sıralamakedisi.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 35),
              const Text(
                'Bağış Sıralaması',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    color: Color.fromRGBO(54, 56, 84, 1.0)),
              ),
              const SizedBox(
                height: 16, // Çubuklar ile yazı arasına bir boşluk eklemek için
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .orderBy('donationCount', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    List<QueryDocumentSnapshot>? documents =
                        snapshot.data?.docs;

                    return ListView.builder(
                      itemCount: documents?.length ?? 0,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = documents![index];
                        String username = document['username'];
                        int donationCount = document['donationCount'];

                        // Defining images for the first three users to show them on the list
                        String? imageAsset;
                        if (index == 0) {
                          imageAsset = 'lib/assets/birincilikk.png';
                        } else if (index == 1) {
                          imageAsset = 'lib/assets/ikincilikk.png';
                        } else if (index == 2) {
                          imageAsset = 'lib/assets/ucunculuk_ic.png';
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(185, 187, 223, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 35),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              if (index < 3 &&
                                  imageAsset !=
                                      null) // Check if it's the first three users to assign the related images.
                                Image.asset(
                                  imageAsset,
                                  width: 24,
                                  height: 24,
                                ),
                              const SizedBox(width: 10),
                              Text(
                                (index < 3 ? '' : '${index + 1}. '),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  username,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                '$donationCount',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context)
                .padding
                .top,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(54, 56, 84, 1.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}