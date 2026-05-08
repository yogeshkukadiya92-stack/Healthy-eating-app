import { AdminShell } from "../components/AdminShell";
import { supabaseAdmin } from "../lib/supabase";

export default async function Page() {
  const [{ count: users }, { count: foods }, { count: analyses }, { count: subs }] = await Promise.all([
    supabaseAdmin.from("profiles").select("*", { count: "exact", head: true }),
    supabaseAdmin.from("foods").select("*", { count: "exact", head: true }),
    supabaseAdmin.from("ai_food_analyses").select("*", { count: "exact", head: true }),
    supabaseAdmin.from("subscriptions").select("*", { count: "exact", head: true }).eq("status", "active"),
  ]);

  return (
    <AdminShell>
      <h1>Overview</h1>
      <div className="grid">
        <div className="card"><div className="metric">{users ?? 0}</div><p>Users</p></div>
        <div className="card"><div className="metric">{foods ?? 0}</div><p>Foods</p></div>
        <div className="card"><div className="metric">{analyses ?? 0}</div><p>AI scans</p></div>
        <div className="card"><div className="metric">{subs ?? 0}</div><p>Active premium</p></div>
      </div>
      <div className="card" style={{ marginTop: 18 }}>
        <h2>Admin operations</h2>
        <p>Manage food data, push campaigns, subscriptions, reports, and AI review queues from one focused console.</p>
      </div>
    </AdminShell>
  );
}
