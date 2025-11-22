import 'package:flutter/material.dart';
import 'package:vivofit/theme/color_palette.dart';

class ProfessionalsScreen extends StatefulWidget {
  const ProfessionalsScreen({super.key});

  @override
  State<ProfessionalsScreen> createState() => _ProfessionalsScreenState();
}

class _ProfessionalsScreenState extends State<ProfessionalsScreen> {
  String _selectedCategory = 'all';

  // Mock Data de Profesionales
  final List<_Professional> _allProfessionals = [
    _Professional(
      id: '1',
      name: 'Dra. Ana García',
      role: 'Nutricionista Clínica',
      category: 'nutrition',
      avatarUrl: 'assets/images/avatars/1.png',
      description:
          'Especialista en nutrición clínica con más de 10 años de experiencia ayudando a pacientes a alcanzar sus objetivos de salud mediante planes personalizados.',
      socialLinks: {
        'whatsapp': '+58 412 1234567',
        'linkedin': 'linkedin.com/in/ana-garcia'
      },
    ),
    _Professional(
      id: '2',
      name: 'Carlos Rodríguez',
      role: 'Coach de CrossFit',
      category: 'coach',
      avatarUrl: 'assets/images/avatars/2.png',
      description:
          'Coach certificado de CrossFit Nivel 2. Apasionado por el entrenamiento funcional y el desarrollo de la fuerza y resistencia.',
      socialLinks: {
        'instagram': '@carlos_crossfit',
        'whatsapp': '+58 414 9876543'
      },
    ),
    _Professional(
      id: '3',
      name: 'Dr. Miguel Ángel',
      role: 'Medicina Deportiva',
      category: 'medical',
      avatarUrl: 'assets/images/avatars/3.png',
      description:
          'Médico especialista en medicina deportiva y traumatología. Experto en prevención y recuperación de lesiones en atletas de alto rendimiento.',
      socialLinks: {
        'linkedin': 'linkedin.com/in/dr-miguel',
        'twitter': '@drmiguelsport'
      },
    ),
    _Professional(
      id: '4',
      name: 'Laura Martínez',
      role: 'Coach de Yoga',
      category: 'coach',
      avatarUrl: 'assets/images/avatars/4.png',
      description:
          'Instructora de Yoga RYT 500. Enfocada en la conexión mente-cuerpo y la mejora de la flexibilidad y el bienestar mental.',
      socialLinks: {'instagram': '@laura_yoga', 'telegram': '@laurayoga'},
    ),
    _Professional(
      id: '5',
      name: 'Pedro Sánchez',
      role: 'Fisioterapeuta',
      category: 'medical',
      avatarUrl: 'assets/images/avatars/5.png',
      description:
          'Fisioterapeuta con especialización en rehabilitación ortopédica. Ayudo a recuperar la movilidad y eliminar el dolor crónico.',
      socialLinks: {
        'whatsapp': '+58 424 1122334',
        'linkedin': 'linkedin.com/in/pedro-physio'
      },
    ),
    _Professional(
      id: '6',
      name: 'Sofía López',
      role: 'Nutricionista Deportiva',
      category: 'nutrition',
      avatarUrl: 'assets/images/avatars/6.png',
      description:
          'Nutricionista enfocada en el rendimiento deportivo. Planificación dietética para atletas y personas activas que buscan maximizar sus resultados.',
      socialLinks: {'instagram': '@sofia_nutri', 'whatsapp': '+58 416 5556677'},
    ),
  ];

  List<_Professional> get _filteredProfessionals {
    if (_selectedCategory == 'all') {
      return _allProfessionals;
    }
    return _allProfessionals
        .where((p) => p.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorPalette.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Panel de expertos',
          style: TextStyle(
            color: ColorPalette.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Header con contador y botón de acción
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_allProfessionals.length} profesionales',
                  style: const TextStyle(
                    color: ColorPalette.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Acción genérica o "Ver todos"
                    setState(() {
                      _selectedCategory = 'all';
                    });
                  },
                  child: const Text(
                    'VER TODOS',
                    style: TextStyle(
                      color: ColorPalette.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Filtros de Categoría
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('all', 'Todos'),
                _buildFilterChip('nutrition', 'Nutrición'),
                _buildFilterChip('coach', 'Coach'),
                _buildFilterChip('medical', 'Médicos'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Lista de Profesionales
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredProfessionals.length,
              separatorBuilder: (context, index) => const Divider(
                color: ColorPalette.cardBackground,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final professional = _filteredProfessionals[index];
                return _buildProfessionalItem(professional);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedCategory == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = value;
          });
        },
        backgroundColor: Colors.transparent,
        selectedColor: ColorPalette.primary,
        checkmarkColor: Colors.black,
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : ColorPalette.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.white,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalItem(_Professional professional) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfessionalDetailScreen(professional: professional),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: ColorPalette.cardBackground,
              // backgroundImage: AssetImage(professional.avatarUrl), // Descomentar cuando existan assets
              child: Text(
                professional.name[0],
                style: const TextStyle(
                  color: ColorPalette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professional.name,
                    style: const TextStyle(
                      color: ColorPalette.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _getCategoryIcon(professional.category),
                        size: 14,
                        color: ColorPalette.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        professional.role,
                        style: const TextStyle(
                          color: ColorPalette.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Button
            Container(
              decoration: BoxDecoration(
                color: ColorPalette.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: ColorPalette.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon:
                    const Icon(Icons.chat_bubble_outline, color: Colors.black),
                onPressed: () => _showContactOptions(context, professional),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'nutrition':
        return Icons.restaurant_menu;
      case 'coach':
        return Icons.fitness_center;
      case 'medical':
        return Icons.medical_services;
      default:
        return Icons.work;
    }
  }

  void _showContactOptions(BuildContext context, _Professional professional) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorPalette.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contactar a ${professional.name}',
              style: const TextStyle(
                color: ColorPalette.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildContactOption(Icons.chat, 'WhatsApp', Colors.green),
            _buildContactOption(Icons.send, 'Telegram', Colors.blue),
            _buildContactOption(
                Icons.chat_bubble, 'Line', Colors.green.shade700),
            _buildContactOption(Icons.close, 'X (Twitter)', Colors.white),
            _buildContactOption(
                Icons.business, 'LinkedIn', Colors.blue.shade800),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(IconData icon, String label, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        label,
        style: const TextStyle(color: ColorPalette.textPrimary),
      ),
      onTap: () {
        Navigator.pop(context);
        // Here we would launch the URL
      },
    );
  }
}

class ProfessionalDetailScreen extends StatelessWidget {
  final _Professional professional;

  const ProfessionalDetailScreen({super.key, required this.professional});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorPalette.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: ColorPalette.cardBackground,
              child: Text(
                professional.name[0],
                style: const TextStyle(
                    fontSize: 40, color: ColorPalette.textPrimary),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              professional.name,
              style: const TextStyle(
                color: ColorPalette.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              professional.role,
              style: const TextStyle(
                color: ColorPalette.primary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorPalette.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sobre mí',
                    style: TextStyle(
                      color: ColorPalette.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    professional.description,
                    style: const TextStyle(
                      color: ColorPalette.textSecondary,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Professional {
  final String id;
  final String name;
  final String role;
  final String category;
  final String avatarUrl;
  final String description;
  final Map<String, String> socialLinks;

  _Professional({
    required this.id,
    required this.name,
    required this.role,
    required this.category,
    required this.avatarUrl,
    required this.description,
    required this.socialLinks,
  });
}
