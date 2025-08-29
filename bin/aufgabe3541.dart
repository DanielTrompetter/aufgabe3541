import 'dart:io';

List<String?> jobs = [];
List<bool> doneJobs = [];

enum Command
{
  help,
  add,
  list,
  done,
  exit
}

Map<String, Command> commands =
{
  "help":Command.help,
  "add":Command.add,
  "list":Command.list,
  "done":Command.done,
  "exit":Command.exit
};

String? parameter;

void main() 
{
  while(true)
  {
    showMenu();
  }
}

void showMenu()
{
  print("Wähle Aktion aus:");
  print("=================");
  print("(help) Zeige diese Auswahl an Kommandos wieder an");
  print("(add <aufgabe>) Füge eine Aufgabe hinzu");
  print("(list) zeige alle Aufgaben");
  print("(done <nummer>) Aufgabe als erledigt markieren");
  print("(exit) Beenden");
  print("----------------------------------------------");
  print("Deine Eingabe:");

  while(true)
  {
    String? input = stdin.readLineSync();
    if(input != null)
    {
      Command? cmd =  getCommand(input);
      switch(cmd)
      {
        case Command.help:
          return;
        case Command.add:
          addJob(input);
        case Command.done:
          jobDone(input);
        case Command.list:
          listJobs();
        case Command.exit:
          exit(0);
        default:
          print("Keine gültige Eingabe!");
      }
    }
  }
}

void addJob(String input)
{
  String? newJob = getParams(input, "add");
  if(newJob == null)
  {
    print("ungültige parameter!");
    return;
  }
  jobs.add(newJob);
  doneJobs.add(false);
}

void listJobs()
{
  print("Liste deiner bisherigen Aufgaben:");
  print("---------------------------------");
  int counter = 1;
  for(String? job in jobs)
  {
    bool done = doneJobs[counter-1];
    print("[${done?'x':' '}] $counter. $job");
    counter++;
  }
}

void jobDone(String input)
{
  String? doneString = getParams(input, "done");
  if(doneString == null)
  {
    print("ungültige parameter!");
    return;
  }
  int? number = int.tryParse(doneString);

  if(number == null)
  {
    print("Ungültige Eingabe!");
    return;
  }
  if(number-1<0 || number-1 > doneJobs.length) 
  {
    print("Aufgabe $number nicht vorhanden!");
    return;
  }
  doneJobs[number-1] = true;
}

Command? getCommand(String input)
{
  Command? result;
  for(String cmdName in commands.keys)
  {
    if(input.length >= cmdName.length)
    {
      result = commands[cmdName];
      for(int i=0;i<cmdName.length;i++)
      {
        if(cmdName[i] != input[i])
        {
          result = null;
          break;
        }
      }
      if(result != null)
      {
        break;
      }
    }
  }
  return result;
}

String? getParams(String input, String commandToCheck)
{
  String givenCommand = "";
  String result = "";
  // seek first space and copy command
  int startcounter = 0;
  for(int i = 0;i<input.length;i++)
  {
    if(input[i]!=' ')
    {
      givenCommand += input[i];
      startcounter++;
    }
    else
    {
      break;
    }
  }
  // check if it is really the given command to check
  if(givenCommand != commandToCheck)
  {
    return null;
  }
  // check if there really are parameters!
  if(startcounter>=input.length)
  {
    return null;
  }
  // insert remaining chars into result but skip leading spaces
  bool paramsFound = false;
  for(int i = startcounter;i<input.length;i++)
  {
    if(!paramsFound && input[i] != ' ')
    {
      paramsFound = true;
    }

    if(paramsFound) result+= input[i];
  }
  return result;
}
