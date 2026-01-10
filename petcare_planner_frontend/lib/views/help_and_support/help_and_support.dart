// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/widgets/faq_card.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allFaqs = [
    {
      "question": "How do I add a new pet to my profile?",
      "answer":
          "You can add a new pet by navigating to the Profile tab and tapping on Add New Pet.",
    },
    {
      "question": "How do I set up reminders for tasks?",
      "answer":
          "Go to the Task Planner, select a task, and enable reminders from the options.",
    },
    {
      "question": "Can I track multiple pets at once?",
      "answer":
          "Yes, PetCare Planner allows you to manage and track unlimited pets.",
    },
  ];

  late List<Map<String, String>> _filteredFaqs;

  @override
  void initState() {
    super.initState();
    _filteredFaqs = List.from(_allFaqs);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredFaqs = _allFaqs.where((faq) {
        return faq["question"]!.toLowerCase().contains(query) ||
            faq["answer"]!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _backButton(context),
                  const Text(
                    "Help & Support",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 24),

              /// --- Hero Card ---
              _heroCard(),

              const SizedBox(height: 20),

              /// --- Search Bar --
              _searchBar(),

              const SizedBox(height: 30),

              /// --- FAQ Section ---
              const Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontFamily: "Poppins-Bold",
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              if (_filteredFaqs.isEmpty)
                Text(
                  "No results found",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    color: AppColors.textPrimary.withOpacity(0.6),
                  ),
                )
              else
                ..._filteredFaqs.map(
                  (faq) => FAQCard(
                    question: faq["question"]!,
                    answer: faq["answer"]!,
                  ),
                ),

              const SizedBox(height: 30),

              /// --- Contact Support ---
              const Text(
                "Contact Support",
                style: TextStyle(
                  fontFamily: "Poppins-Bold",
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              _contactCard(
                icon: Icons.email_outlined,
                title: "Email Support",
                subtitle: "support.petcare@gmail.com",
                onTap: () => _launchEmail("support.petcare@gmail.com"),
              ),
              const SizedBox(height: 12),
              _contactCard(
                icon: Icons.phone_outlined,
                title: "Phone Support",
                subtitle: "+977-9767231664\n(Mon–Fri, 9AM–6PM)",
                onTap: () => _launchPhone("+9779767231664"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widgets

  Widget _backButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.chevron_left, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How can we help you?",
            style: TextStyle(
              fontFamily: "Poppins-Bold",
              fontSize: 22,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Find answers, contact support, or explore resources",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: "Search for help...",
          hintStyle: TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            color: AppColors.textPrimary.withOpacity(0.5),
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.textPrimary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.background),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
