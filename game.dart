import 'dart:io';
import 'dart:math';

// Data structure for Player to acces and review play i am going to be the worlds greatest developer in a year 
class Player {
//well i am cooked 
  String name;
  int health;
  int gold;
  List<String> inventory;
  Set<String> activeEffects;

  Player(this.name)
      : health = 100,
// Data structure for Monster
class Monster {
  String name;
  int health;
  int minDamage;
  int maxDamage;

  Monster(this.name, this.health, this.minDamage, this.maxDamage);

  int attack(Random rng) => rng.nextInt(maxDamage - minDamage + 1) + minDamage;
}

// Main Game Class
class DungeonGame {
  final Random rng = Random();
  late Player player;

  void start() {
    stdout.write("Enter your name: ");
    String? inputName = stdin.readLineSync();
    player = Player(inputName ?? "Hero");

    while (player.health > 0) {
      String event = _randomEvent();

      if (event == "monster") {
        _battleMonster();
      } else if (event == "chest") {
        _openChest();
      } else {
        print("The room is empty...");
      }

      player.showStatus();

      stdout.write("Choose [continue/use/quit]: ");
      String? choice = stdin.readLineSync();

      if (choice == "use") {
        _useItem();
      } else if (choice == "quit") {
        print("You leave the dungeon with your loot!");
        break;
      }
    }

    if (player.health <= 0) {
      print("💀 Game Over, ${player.name}");
    }
  }

  // Pick random event
  String _randomEvent() {
    List<String> events = ["monster", "chest", "nothing"];
    return events[rng.nextInt(events.length)];
  }

  // Battle sequence
  void _battleMonster() {
    List<String> monsterNames = ["Goblin", "Orc", "Skeleton"];
    String name = monsterNames[rng.nextInt(monsterNames.length)];
    int health = rng.nextInt(21) + 20; // 20–40
    Monster monster = Monster(name, health, 5, 12);

    print("⚔️ A wild $name appears with $health HP!");

    while (monster.health > 0 && player.health > 0) {
      stdout.write("Do you want to [attack/run]? ");
      String? action = stdin.readLineSync();

      if (action == "attack") {
        int damage = rng.nextInt(11) + 5; // 5–15
        if (player.activeEffects.contains("amulet")) {
          damage += 5;
          player.activeEffects.remove("amulet");
        }

        monster.health -= damage;
        print("You strike the $name for $damage damage!");

        if (monster.health > 0) {
          int monsterDamage = monster.attack(rng);
          if (player.activeEffects.contains("shield")) {
            monsterDamage ~/= 2;
            player.activeEffects.remove("shield");
          }
          player.health -= monsterDamage;
          print("$name hits you for $monsterDamage damage!");
        }
      } else if (action == "run") {
        print("You run away safely!");
        return;
      }
    }

    if (player.health > 0) {
      int reward = rng.nextInt(21) + 10; // 10–30
      player.gold += reward;
      print("🎉 You defeated the $name and found $reward gold!");
    }
  }

  // Open chest event
  void _openChest() {
    List<String> items = ["potion", "shield", "amulet"];
    String reward = items[rng.nextInt(items.length)];
    player.inventory.add(reward);
    print("📦 You found a $reward in the chest!");
  }

  // Use item from inventory
  void _useItem() {
    if (player.inventory.isEmpty) {
      print("No items in inventory.");
      return;
    }

    print("Your items: ${player.inventory}");
    stdout.write("Which item do you want to use? ");
    String? choice = stdin.readLineSync();

    if (choice == "potion" && player.inventory.contains("potion")) {
      player.health += 20;
      player.inventory.remove("potion");
      print("You drank a potion and restored 20 health!");
    } else if (choice == "shield" && player.inventory.contains("shield")) {
      player.activeEffects.add("shield");
      player.inventory.remove("shield");
      print("Shield activated! Next attack will be halved.");
    } else if (choice == "amulet" && player.inventory.contains("amulet")) {
      player.activeEffects.add("amulet");
      player.inventory.remove("amulet");
      print("Amulet activated! Next attack will deal extra damage.");
    } else {
      print("Invalid choice or item not available.");
    }
  }
}

void main() {
  DungeonGame game = DungeonGame();
  game.start();
}
