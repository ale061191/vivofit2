import 'package:flutter/material.dart';
import 'package:vivofit/theme/color_palette.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header con División y Tiempo
            _buildHeader(),

            // 2. Lista Horizontal de Escudos (Niveles)
            _buildShieldsList(),

            // 3. Leaderboard (Lista de usuarios)
            Expanded(
              child: _buildLeaderboard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorPalette.cardBackground, width: 1),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'División Plata',
            style: TextStyle(
              color: ColorPalette.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(Icons.access_time,
                  color: ColorPalette.primary, size: 18),
              SizedBox(width: 4),
              Text(
                '1 DÍA',
                style: TextStyle(
                  color: ColorPalette.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShieldsList() {
    // 10 Niveles
    final levels = List.generate(10, (index) => index + 1);
    const currentLevel = 2; // Supongamos que el usuario está en nivel 2 (Plata)

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: levels.length,
        separatorBuilder: (context, index) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final level = levels[index];
          final isUnlocked = level <= currentLevel;
          final isCurrent = level == currentLevel;

          return Column(
            children: [
              Icon(
                isUnlocked ? Icons.shield : Icons.shield_outlined,
                size: 40,
                color: isCurrent
                    ? Colors.white // Nivel actual destacado
                    : isUnlocked
                        ? _getLevelColor(level) // Niveles pasados con su color
                        : ColorPalette
                            .cardBackground, // Niveles futuros bloqueados
              ),
              if (isCurrent)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 20,
                  height: 3,
                  decoration: BoxDecoration(
                    color: ColorPalette.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeaderboard() {
    // Mock Data de usuarios
    final users = [
      _RankingUser(
          1, 'Sara Rodríguez', 40, true, 'assets/images/avatars/1.png'),
      _RankingUser(
          2, 'Oliver Salomons', 30, true, 'assets/images/avatars/2.png'),
      _RankingUser(3, 'hebeleticia', 30, true, 'assets/images/avatars/3.png'),
      _RankingUser(
          4, 'frailinis campo', 25, true, 'assets/images/avatars/4.png'),
      _RankingUser(
          5, 'Daniela Moraes', 25, true, 'assets/images/avatars/5.png'),
      _RankingUser(6, 'Alicia vitoria', 23, false,
          'assets/images/avatars/6.png'), // Usuario actual
      _RankingUser(
          7, 'gloriangel Santana', 23, true, 'assets/images/avatars/7.png'),
      _RankingUser(8, 'Carlos Perez', 20, true, null),
      _RankingUser(9, 'Maria Garcia', 18, true, null),
      _RankingUser(10, 'Juan Lopez', 15, true, null),
      _RankingUser(11, 'Ana Martinez', 12, true, null),
      _RankingUser(12, 'Pedro Sanchez', 10, true, null),
      _RankingUser(13, 'Lucia Torres', 8, true, null),
      _RankingUser(14, 'Miguel Ruiz', 5, true, null),
      _RankingUser(15, 'Sofia Diaz', 4, true, null),
      _RankingUser(16, 'Javier Castro', 3, true, null),
      _RankingUser(17, 'Elena Morales', 2, true, null),
      _RankingUser(18, 'Diego Ortiz', 1, true, null),
      _RankingUser(19, 'Carmen Silva', 0, true, null),
      _RankingUser(20, 'Roberto Nuñez', 0, true, null),
    ];

    return ListView.builder(
      itemCount:
          users.length + 2, // +2 para los separadores (Ascenso y Descenso)
      itemBuilder: (context, index) {
        // Separador de Zona de Ascenso (Después del rank 10)
        // Indices 0-9 son ranks 1-10. Index 10 es el separador.
        if (index == 10) {
          return _buildZoneSeparator(
            'Zona de ascenso',
            Colors.green,
            Icons.arrow_upward,
          );
        }

        // Separador de Zona de Descenso (Antes del rank 15)
        // Indices 11-14 son ranks 11-14. Index 15 es el separador.
        if (index == 15) {
          return _buildZoneSeparator(
            'Zona de descenso',
            ColorPalette.error, // Rojo
            Icons.arrow_downward,
          );
        }

        // Calcular índice de usuario en el array
        int userIndex = index;
        if (index > 10) userIndex--; // Ajuste por primer separador
        if (index > 15) userIndex--; // Ajuste por segundo separador

        if (userIndex >= users.length) return const SizedBox();

        final user = users[userIndex];
        final isCurrentUser = userIndex == 5; // Simulamos que somos el 6to

        return Container(
          color: isCurrentUser ? ColorPalette.cardBackground : null,
          child: ListTile(
            leading: _buildRankLeading(user.rank),
            title: Text(
              user.name,
              style: TextStyle(
                color: isCurrentUser
                    ? ColorPalette.primary
                    : ColorPalette.textPrimary,
                fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: Text(
              '${user.xp} EXP',
              style: const TextStyle(
                color: ColorPalette.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Avatar del usuario
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            minLeadingWidth: 40,
          ),
        );
      },
    );
  }

  Widget _buildRankLeading(int rank) {
    // Ranks 1, 2, 3 con Escudos
    if (rank <= 3) {
      Color shieldColor;
      if (rank == 1) {
        shieldColor = const Color(0xFFFFD700); // Oro
      } else if (rank == 2) {
        shieldColor = const Color(0xFFC0C0C0); // Plata
      } else {
        shieldColor = const Color(0xFFCD7F32); // Bronce
      }

      return SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.shield, color: shieldColor, size: 32),
            Text(
              '$rank',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    // Colores para los números
    Color textColor = ColorPalette.textPrimary;
    if (rank <= 10) {
      textColor = Colors.green; // Zona de ascenso
    } else if (rank >= 15) {
      textColor = ColorPalette.error; // Zona de descenso
    }

    return SizedBox(
      width: 40,
      child: Center(
        child: Text(
          '$rank',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildZoneSeparator(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: Divider(color: color, indent: 8)),
        ],
      ),
    );
  }

  Color _getLevelColor(int level) {
    // Colores para los escudos según nivel
    switch (level) {
      case 1:
        return Colors.blue; // Principiante (Azul solicitado)
      case 2:
        return Colors.grey; // Plata
      case 3:
        return Colors.amber; // Oro
      case 4:
        return Colors.cyan; // Diamante
      default:
        return Colors.purple; // Leyenda
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Oro
      case 2:
        return const Color(0xFFC0C0C0); // Plata
      case 3:
        return const Color(0xFFCD7F32); // Bronce
      default:
        return ColorPalette.primary; // Verde/Naranja app
    }
  }
}

class _RankingUser {
  final int rank;
  final String name;
  final int xp;
  final bool isOnline;
  final String? avatarUrl;

  _RankingUser(this.rank, this.name, this.xp, this.isOnline, this.avatarUrl);
}
