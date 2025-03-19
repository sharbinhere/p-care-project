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
      appBar: AppBar(
        title: Text('Patients List',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        backgroundColor: Color.fromARGB(255, 37, 100, 228),
      ),
      body: Obx(() {
        if (patienceListController.patients.isEmpty) {
          return Center(
            child: Text(
              'No patients found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          itemCount: patienceListController.patients.length,
          separatorBuilder: (context, index) => Divider(
            color: Color.fromARGB(255, 77, 129, 231),
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          itemBuilder: (context, index) {
            var patient = patienceListController.patients[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  patient['name'] ?? 'No Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 37, 100, 228),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.cake, color: Color.fromARGB(255, 37, 100, 228), size: 16),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text("Age: ${patient['age'] ?? 'N/A'}")),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.home, color: Color.fromARGB(255, 37, 100, 228), size: 16),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text(
                                "Address: ${patient['address'] ?? 'N/A'}")),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Color.fromARGB(255, 37, 100, 228), size: 16),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text("Phone: ${patient['phone'] ?? 'N/A'}")),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.medical_services,
                            color: Color.fromARGB(255, 37, 100, 228), size: 16),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text(
                                "Diagnosis: ${patient['diagnosis'] ?? 'N/A'}")),
                      ],
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Color.fromARGB(255, 37, 100, 228),
                ),
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
