
LifeLog - A Daily Journaling AppLifeLog is a simple, secure, and cross-platform (iOS & Android) mobile application for capturing your daily thoughts and moods. Built with Flutter and Supabase, it provides a seamless and private journaling experience. 

Key FeaturesSecure Authentication: 
Email/password sign-up and login powered by Supabase Auth.Daily Entries: Create journal entries with a title, body text, and a mood rating from 1 to 5.Data Privacy: User data is protected using Supabase's Row-Level Security, ensuring you can only see your own entries.Real-time Updates: Your journal list updates in real-time across devices.One-per-Day Limit: Enforces a single journal entry per day to encourage concise, mindful reflection.🛠️ Tech StackFrontend: FlutterBackend & Database: SupabaseState Management: Flutter RiverpodServerless Logic: Supabase Edge Functions 

Setup Instructions to get this project running locally, follow these 
Supabase Backend SetupCreate a Supabase Project: Go to supabase.com, create a new project, and save your Project URL and anon key.Run the SQL Schema: In the Supabase dashboard, go to the SQL Editor, and run the following script to create the journal_entries table and its constraints:-- Create the journal_entries table

Schema Design Decisions The database schema was designed for data integrity and performance.

Assumptions and TradeoffsEdge Function for Creation: 
The decision to use an Edge Function for creating new entries was a deliberate tradeoff.Pro: It centralizes the business logic for creating an entry, including handling the potential "unique constraint" error and returning a user-friendly message.Con: 

Known Limitations:
No Edit/Delete The current version of the app does not allow users to edit or delete their journal entries.Minimalist UI: The user interface is functional and clean but does not include complex animations or theming.Basic 
Error Handling: Error messages are presented via SnackBar widgets. A more advanced implementation might use custom dialogs for a more integrated feel.
>>>>>>> 70de2b53432241ef1b1ede63631292b7de8048bd
