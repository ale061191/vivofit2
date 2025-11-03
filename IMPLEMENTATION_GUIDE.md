# 📘 Guía de Implementación - Vivofit

Esta guía complementaria proporciona detalles técnicos para completar las funcionalidades pendientes de la aplicación.

## 🎥 Implementación de Video Player

### Pantalla: `routine_detail_screen.dart`

```dart
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class RoutineDetailScreen extends StatefulWidget {
  final String routineId;
  const RoutineDetailScreen({super.key, required this.routineId});

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isLocked = true; // Verificar membresía

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // Verificar si usuario tiene acceso
    final userService = context.read<UserService>();
    _isLocked = !userService.hasMembership(routine.programId);

    if (!_isLocked && routine.videoUrl != null) {
      _videoController = VideoPlayerController.network(routine.videoUrl!);
      await _videoController.initialize();
      
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: false,
        looping: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: ColorPalette.primary,
        ),
      );
      
      setState(() {});
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(routine.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Video player
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _isLocked
                  ? LockedContentOverlay(
                      message: 'Video Premium',
                      onUnlockTap: () => AppRoutes.goToPayment(context, routine.programId),
                    )
                  : _chewieController != null
                      ? Chewie(controller: _chewieController!)
                      : LoadingIndicator(),
            ),
            
            // Detalles de la rutina
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(routine.name, style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: 8),
                  Text(routine.description),
                  SizedBox(height: 16),
                  
                  // Lista de ejercicios
                  Text('Ejercicios', style: Theme.of(context).textTheme.titleLarge),
                  ...routine.exercises.map((exercise) => ListTile(
                    title: Text(exercise.name),
                    subtitle: Text('${exercise.sets} series × ${exercise.reps} reps'),
                    trailing: Text('${exercise.restSeconds}s'),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 📝 Implementación de Edición de Perfil

### Pantalla: `edit_profile_screen.dart`

```dart
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = context.read<UserService>().user;
    if (user != null) {
      _nameController.text = user.name;
      _ageController.text = user.age?.toString() ?? '';
      _heightController.text = user.height?.toString() ?? '';
      _weightController.text = user.weight?.toString() ?? '';
      _phoneController.text = user.phone ?? '';
      _locationController.text = user.location ?? '';
      _selectedGender = user.gender;
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final userService = context.read<UserService>();
    final success = await userService.updateProfile(
      name: _nameController.text,
      age: int.tryParse(_ageController.text),
      height: double.tryParse(_heightController.text),
      weight: double.tryParse(_weightController.text),
      phone: _phoneController.text,
      location: _locationController.text,
      gender: _selectedGender,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil actualizado'), backgroundColor: ColorPalette.success),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Cambiar foto
              GestureDetector(
                onTap: () async {
                  await context.read<UserService>().updateProfilePhoto();
                },
                child: Stack(
                  children: [
                    CircleAvatar(radius: 60, /* foto */),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: ColorPalette.primary,
                        child: Icon(Icons.camera_alt, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              TextFormField(
                controller: _nameController,
                validator: Validators.name,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              
              SizedBox(height: 16),
              
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                validator: Validators.age,
                decoration: InputDecoration(labelText: 'Edad'),
              ),
              
              SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      validator: Validators.height,
                      decoration: InputDecoration(
                        labelText: 'Altura (cm)',
                        suffixText: 'cm',
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      validator: Validators.weight,
                      decoration: InputDecoration(
                        labelText: 'Peso (kg)',
                        suffixText: 'kg',
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(labelText: 'Sexo'),
                items: [
                  DropdownMenuItem(value: 'male', child: Text('Masculino')),
                  DropdownMenuItem(value: 'female', child: Text('Femenino')),
                  DropdownMenuItem(value: 'other', child: Text('Otro')),
                ],
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              
              SizedBox(height: 16),
              
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: Validators.phoneVenezuela,
                decoration: InputDecoration(labelText: 'Teléfono'),
              ),
              
              SizedBox(height: 16),
              
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Ubicación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 📅 Implementación de Activación de Membresía

### Pantalla: `activate_membership_screen.dart`

```dart
import 'package:table_calendar/table_calendar.dart';

class ActivateMembershipScreen extends StatefulWidget {
  final String? programId;
  const ActivateMembershipScreen({super.key, this.programId});

  @override
  State<ActivateMembershipScreen> createState() => _ActivateMembershipScreenState();
}

class _ActivateMembershipScreenState extends State<ActivateMembershipScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Program? _selectedProgram;
  final List<Program> _programs = Program.mockList();

  @override
  void initState() {
    super.initState();
    if (widget.programId != null) {
      _selectedProgram = _programs.firstWhere((p) => p.id == widget.programId);
    }
  }

  Future<void> _activateMembership() async {
    if (_selectedProgram == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona un programa')),
      );
      return;
    }

    // Navegar a pantalla de pago
    AppRoutes.goToPayment(context, _selectedProgram!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Activar Membresía')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de programa
            Text('Selecciona un Programa', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 12),
            
            DropdownButtonFormField<Program>(
              value: _selectedProgram,
              decoration: InputDecoration(
                labelText: 'Programa',
                border: OutlineInputBorder(),
              ),
              items: _programs.map((program) {
                return DropdownMenuItem(
                  value: program,
                  child: Text(program.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedProgram = value),
            ),
            
            SizedBox(height: 24),
            
            // Calendario para fecha de vencimiento
            Text('Fecha de Vencimiento', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 12),
            
            Container(
              decoration: BoxDecoration(
                color: ColorPalette.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: ColorPalette.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: ColorPalette.primary.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Resumen
            if (_selectedProgram != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorPalette.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Resumen', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 8),
                    Text('Programa: ${_selectedProgram!.name}'),
                    Text('Duración: ${_selectedProgram!.durationWeeks} semanas'),
                    Text('Precio: \$${_selectedProgram!.price}'),
                    Text('Vencimiento: ${Formatters.date(_selectedDate)}'),
                  ],
                ),
              ),
            
            SizedBox(height: 24),
            
            CustomButton(
              text: 'Proceder al Pago',
              onPressed: _activateMembership,
              icon: Icons.payment,
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🍔 Implementación de Detalle de Alimento

### Pantalla: `food_detail_screen.dart`

```dart
class FoodDetailScreen extends StatelessWidget {
  final String foodId;
  const FoodDetailScreen({super.key, required this.foodId});

  @override
  Widget build(BuildContext context) {
    // Buscar alimento por ID
    final food = Food.mockList().firstWhere((f) => f.id == foodId);

    return Scaffold(
      appBar: AppBar(title: Text(food.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            if (food.imageUrl != null)
              Image.network(
                food.imageUrl!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 250,
                color: ColorPalette.cardBackground,
                child: Center(child: Icon(Icons.restaurant, size: 80)),
              ),
            
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría
                  Chip(
                    label: Text(food.categoryTranslated),
                    backgroundColor: ColorPalette.primary,
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Descripción
                  Text(food.description),
                  
                  SizedBox(height: 24),
                  
                  // Información nutricional
                  Text('Información Nutricional', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 12),
                  
                  _NutritionRow('Calorías', '${food.calories} kcal'),
                  _NutritionRow('Proteínas', '${food.protein}g'),
                  _NutritionRow('Carbohidratos', '${food.carbs}g'),
                  _NutritionRow('Grasas', '${food.fats}g'),
                  _NutritionRow('Tiempo de preparación', '${food.preparationTimeMinutes} min'),
                  _NutritionRow('Porciones', '${food.servings}'),
                  _NutritionRow('Dificultad', food.difficultyTranslated),
                  
                  SizedBox(height: 24),
                  
                  // Ingredientes
                  Text('Ingredientes', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 12),
                  
                  ...food.ingredients.map((ingredient) => Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: ColorPalette.primary, size: 20),
                        SizedBox(width: 8),
                        Expanded(child: Text(ingredient)),
                      ],
                    ),
                  )),
                  
                  SizedBox(height: 24),
                  
                  // Pasos de preparación
                  Text('Preparación', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 12),
                  
                  ...food.preparationSteps.asMap().entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: ColorPalette.primary,
                            radius: 16,
                            child: Text(
                              '${entry.key + 1}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(child: Text(entry.value)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  final String label;
  final String value;

  const _NutritionRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: ColorPalette.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: ColorPalette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
```

## 📖 Implementación de Detalle de Artículo

### Pantalla: `article_detail_screen.dart`

```dart
import 'package:flutter_markdown/flutter_markdown.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String articleId;
  const ArticleDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final article = Article.mockList().firstWhere((a) => a.id == articleId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar con imagen
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                article.title,
                style: TextStyle(
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
              background: article.imageUrl != null
                  ? Image.network(article.imageUrl!, fit: BoxFit.cover)
                  : Container(color: ColorPalette.cardBackground),
            ),
          ),
          
          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Metadata
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(article.authorImageUrl),
                        radius: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.author,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${article.formattedDate} · ${article.readTimeMinutes} min de lectura',
                              style: TextStyle(
                                color: ColorPalette.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        label: Text(article.topicTranslated),
                        backgroundColor: ColorPalette.primary,
                        labelStyle: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ],
                  ),
                  
                  Divider(height: 32),
                  
                  // Contenido en Markdown
                  MarkdownBody(
                    data: article.content,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(fontSize: 16, height: 1.6),
                      h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      h2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      h3: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Stats
                  Row(
                    children: [
                      Icon(Icons.visibility, color: ColorPalette.textTertiary, size: 20),
                      SizedBox(width: 4),
                      Text('${article.views} vistas'),
                      SizedBox(width: 24),
                      Icon(Icons.favorite, color: ColorPalette.primary, size: 20),
                      SizedBox(width: 4),
                      Text('${article.likes} me gusta'),
                    ],
                  ),
                  
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

**Nota**: Necesitarás agregar `flutter_markdown: ^0.6.18` al `pubspec.yaml` para esta funcionalidad.

## 🔧 Consejos de Optimización

1. **Imágenes**: Usa `cached_network_image` para caché automático
2. **Listas**: Implementa paginación para listas largas
3. **Videos**: Implementa pre-carga y buffering
4. **Estado**: Considera mover a Riverpod para mejor performance
5. **Animaciones**: Usa `Hero` widgets para transiciones fluidas

---

¡Con estas implementaciones tendrás una aplicación completamente funcional! 🚀
