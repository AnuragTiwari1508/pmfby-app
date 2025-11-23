import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../models/crop_loss_report.dart';
import 'package:intl/intl.dart';

class CropLossIntimationScreen extends StatefulWidget {
  const CropLossIntimationScreen({super.key});

  @override
  State<CropLossIntimationScreen> createState() => _CropLossIntimationScreenState();
}

class _CropLossIntimationScreenState extends State<CropLossIntimationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Demo data
  final List<CropLossReport> _reports = [
    CropLossReport(
      id: 'CLR001',
      farmerId: 'F12345',
      farmerName: 'Ram Singh',
      cropType: 'Wheat',
      season: 'Rabi 2024-25',
      affectedArea: 2.5,
      lossType: 'Hailstorm',
      lossPercentage: '60-70%',
      incidentDate: DateTime(2024, 11, 15),
      reportedDate: DateTime(2024, 11, 16),
      district: 'Ludhiana',
      village: 'Dhandari',
      latitude: 30.9010,
      longitude: 75.8573,
      description: 'Heavy hailstorm damaged wheat crop in early growth stage',
      imagePaths: ['image1.jpg', 'image2.jpg'],
      status: 'under_review',
      claimNumber: 'CLM2024001',
    ),
    CropLossReport(
      id: 'CLR002',
      farmerId: 'F12345',
      farmerName: 'Ram Singh',
      cropType: 'Rice',
      season: 'Kharif 2024',
      affectedArea: 3.0,
      lossType: 'Flood',
      lossPercentage: '80-90%',
      incidentDate: DateTime(2024, 8, 20),
      reportedDate: DateTime(2024, 8, 21),
      district: 'Ludhiana',
      village: 'Dhandari',
      latitude: 30.9010,
      longitude: 75.8573,
      description: 'Flood water submerged the entire paddy field',
      imagePaths: ['image3.jpg', 'image4.jpg', 'image5.jpg'],
      status: 'approved',
      assessorComments: 'Assessed and approved for compensation',
      assessmentDate: DateTime(2024, 9, 5),
      claimNumber: 'CLM2024002',
    ),
    CropLossReport(
      id: 'CLR003',
      farmerId: 'F12345',
      farmerName: 'Ram Singh',
      cropType: 'Cotton',
      season: 'Kharif 2024',
      affectedArea: 1.5,
      lossType: 'Pest Attack',
      lossPercentage: '40-50%',
      incidentDate: DateTime(2024, 7, 10),
      reportedDate: DateTime(2024, 7, 12),
      district: 'Ludhiana',
      village: 'Dhandari',
      latitude: 30.9010,
      longitude: 75.8573,
      description: 'Pink bollworm infestation in cotton crop',
      imagePaths: ['image6.jpg'],
      status: 'pending_documents',
      assessorComments: 'Please submit pesticide purchase receipts',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade700,
              Colors.white,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: Column(
          children: [
            // Header section
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                bottom: 24,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.support_agent, color: Colors.white),
                        onPressed: _showCustomerCareDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.report_problem,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'फसल नुकसान सूचना',
                    style: GoogleFonts.notoSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Crop Loss Intimation',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Content section with tabs
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    
                    // Tab Bar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey.shade700,
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(text: 'New Report'),
                          Tab(text: 'My Reports'),
                        ],
                      ),
                    ),
                    
                    // Tab Views
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildNewReportTab(),
                          _buildMyReportsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewReportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Instructions Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'How to File Report',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInstructionStep('1', 'Take clear photos of damaged crop'),
                _buildInstructionStep('2', 'Fill in all required details'),
                _buildInstructionStep('3', 'Submit within 72 hours of incident'),
                _buildInstructionStep('4', 'Track status in "My Reports"'),
                const SizedBox(height: 8),
                Text(
                  '⚠️ महत्वपूर्ण: घटना के 72 घंटे के भीतर रिपोर्ट करें',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Take Photos',
                  Icons.camera_alt,
                  Colors.green,
                  () => context.push('/camera'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  'Call Support',
                  Icons.phone,
                  Colors.blue,
                  _showCustomerCareDialog,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // File New Report Button
          ElevatedButton(
            onPressed: () => context.push('/file-crop-loss'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_circle_outline, size: 24),
                const SizedBox(width: 12),
                Text(
                  'File New Crop Loss Report',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Common Loss Types
          Text(
            'Common Loss Types',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildLossTypeChip('Flood', Icons.water),
              _buildLossTypeChip('Drought', Icons.wb_sunny),
              _buildLossTypeChip('Hailstorm', Icons.ac_unit),
              _buildLossTypeChip('Pest Attack', Icons.bug_report),
              _buildLossTypeChip('Disease', Icons.sick),
              _buildLossTypeChip('Fire', Icons.local_fire_department),
            ],
          ),

          const SizedBox(height: 24),

          // Emergency Contact Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.amber.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Emergency Support',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'For urgent crop loss, call 14447 immediately',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyReportsTab() {
    final pendingReports = _reports.where((r) => 
      r.status == 'submitted' || r.status == 'under_review' || r.status == 'pending_documents'
    ).toList();
    
    final completedReports = _reports.where((r) => 
      r.status == 'approved' || r.status == 'rejected'
    ).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Reports',
                  _reports.length.toString(),
                  Icons.description,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Pending',
                  pendingReports.length.toString(),
                  Icons.pending,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Approved',
                  completedReports.where((r) => r.status == 'approved').length.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Pending Reports
          if (pendingReports.isNotEmpty) ...[
            Text(
              'Pending Reports',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            ...pendingReports.map((report) => _buildReportCard(report)),
            const SizedBox(height: 24),
          ],

          // Completed Reports
          if (completedReports.isNotEmpty) ...[
            Text(
              'Completed Reports',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            ...completedReports.map((report) => _buildReportCard(report)),
          ],

          if (_reports.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(Icons.description, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No reports filed yet',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLossTypeChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(
        label,
        style: GoogleFonts.roboto(fontSize: 12),
      ),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(color: Colors.grey.shade300),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 10,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(CropLossReport report) {
    Color statusColor;
    switch (report.status) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      case 'under_review':
        statusColor = Colors.orange;
        break;
      case 'pending_documents':
        statusColor = Colors.amber;
        break;
      default:
        statusColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showReportDetails(report),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      report.getStatusLabel(),
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'ID: ${report.id}',
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.eco, color: Colors.green.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    report.cropType,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${report.season})',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.warning, 'Loss Type:', report.lossType),
              _buildInfoRow(Icons.percent, 'Loss:', report.lossPercentage),
              _buildInfoRow(Icons.square_foot, 'Affected Area:', '${report.affectedArea} hectares'),
              _buildInfoRow(Icons.calendar_today, 'Incident Date:', 
                DateFormat('dd MMM yyyy').format(report.incidentDate)),
              if (report.claimNumber != null)
                _buildInfoRow(Icons.receipt, 'Claim #:', report.claimNumber!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDetails(CropLossReport report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Report Details',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailRow('Report ID', report.id),
              _buildDetailRow('Crop Type', report.cropType),
              _buildDetailRow('Season', report.season),
              _buildDetailRow('Loss Type', report.lossType),
              _buildDetailRow('Loss Percentage', report.lossPercentage),
              _buildDetailRow('Affected Area', '${report.affectedArea} hectares'),
              _buildDetailRow('District', report.district),
              _buildDetailRow('Village', report.village),
              _buildDetailRow('Incident Date', DateFormat('dd MMM yyyy').format(report.incidentDate)),
              _buildDetailRow('Reported Date', DateFormat('dd MMM yyyy').format(report.reportedDate)),
              if (report.claimNumber != null)
                _buildDetailRow('Claim Number', report.claimNumber!),
              const SizedBox(height: 16),
              Text(
                'Description:',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                report.description,
                style: GoogleFonts.roboto(fontSize: 14),
              ),
              if (report.assessorComments != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Assessor Comments:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    report.assessorComments!,
                    style: GoogleFonts.roboto(fontSize: 13),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomerCareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.support_agent, color: Colors.green.shade700, size: 28),
            const SizedBox(width: 12),
            const Text('Customer Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'For crop loss intimation support:',
              style: GoogleFonts.roboto(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: const Text('Call 14447'),
              subtitle: const Text('Toll-Free Helpline'),
              onTap: () {
                Navigator.pop(context);
                // Launch phone
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.green),
              title: const Text('WhatsApp: 7065514447'),
              subtitle: const Text('Chat Support'),
              onTap: () {
                Navigator.pop(context);
                // Launch WhatsApp
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
