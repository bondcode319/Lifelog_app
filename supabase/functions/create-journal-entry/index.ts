// import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
// import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.0.0'

// serve(async (req) => {
//   // 1. Check for Authorization header and create Supabase client
//   const authHeader = req.headers.get('Authorization');
//   if (!authHeader) {
//     return new Response(JSON.stringify({ error: 'Missing Authorization header' }), { status: 401, headers: { 'Content-Type': 'application/json' } });
//   }
//   const supabaseUrl = Deno.env.get('SUPABASE_URL')!
//   const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
//   const supabase = createClient(
//     supabaseUrl,
//     supabaseKey,
//     { global: { headers: { Authorization: authHeader } } }
//   )

//   // 2. Get the current user
//   const { data, error: userError } = await supabase.auth.getUser();
//   if (userError || !data?.user) {
//     return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401, headers: { 'Content-Type': 'application/json' } });
//   }
//   const user = data.user;

//   // 3. Get the request body
//   let body;
//   try {
//     body = await req.json();
//   } catch {
//     return new Response(JSON.stringify({ error: 'Invalid JSON' }), { status: 400, headers: { 'Content-Type': 'application/json' } });
//   }
//   const { title, content, mood } = body;
//   if (!title || !mood) {
//       return new Response(JSON.stringify({ error: 'Title and mood are required.' }), { status: 400, headers: { 'Content-Type': 'application/json' } })
//   }

//   // 4. Server-side validation and creation
//   const entryDate = new Date().toISOString().split('T')[0]; // YYYY-MM-DD format

//   const { data: createdEntry, error: insertError } = await supabase
//     .from('journal_entries')
//     .insert({
//       user_id: user.id,
//       title: title,
//       content: content,
//       mood: mood,
//       entry_date: entryDate,
//     })
//     .select()
//     .single() // Return the created object

//   if (insertError) {
//     // Handle the unique constraint violation gracefully
//     if (insertError.code === '23505') { // Postgres code for unique_violation
//       return new Response(JSON.stringify({ error: 'An entry for today already exists.' }), { status: 409, headers: { 'Content-Type': 'application/json' } })
//     }
//     return new Response(JSON.stringify({ error: insertError.message }), { status: 500, headers: { 'Content-Type': 'application/json' } })
//   }

//   return new Response(JSON.stringify(createdEntry), {
//     headers: { 'Content-Type': 'application/json' },
//     status: 201, // 201 Created
//   })
// })