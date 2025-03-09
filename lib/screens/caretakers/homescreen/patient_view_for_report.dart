import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/screens/caretakers/homescreen/patient_report_screen.dart';
import 'package:p_care/services/patients/patient_list_controller.dart';

class PatientsViewScreen extends StatelessWidget {
  final PatienceListController patienceListController =
      Get.find<PatienceListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patients List')),
      body: Obx(() {
        if (patienceListController.patients.isEmpty) {
          return Center(child: Text('No patients found'));
        }

        return ListView.builder(
          itemCount: patienceListController.patients.length,
          itemBuilder: (context, index) {
            var patient = patienceListController.patients[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(patient['name'] ?? 'No Name'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Age: ${patient['age'] ?? 'N/A'}"),
                    Text("Address: ${patient['address'] ?? 'N/A'}"),
                    Text("Phone: ${patient['phone'] ?? 'N/A'}"),
                    Text("Diagnosis: ${patient['diagnosis'] ?? 'N/A'}"),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Get.to(() => PatientReportScreen(
                        patientId: patient['patientId'], // Pass patientId
                        patientName: patient['name'], // Pass patientName
                      ));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
