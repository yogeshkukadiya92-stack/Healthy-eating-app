import { AdminShell } from "../../components/AdminShell";
import { supabaseAdmin } from "../../lib/supabase";

export default async function ModerationPage() {
  const { data } = await supabaseAdmin.from("ai_food_analyses").select("id,user_id,provider,confidence,created_at,detected_items").limit(50);

  return (
    <AdminShell>
      <h1>AI moderation</h1>
      <div className="card">
        <table>
          <thead><tr><th>User</th><th>Provider</th><th>Confidence</th><th>Created</th><th>Items</th></tr></thead>
          <tbody>
            {(data ?? []).map((row) => (
              <tr key={row.id}>
                <td>{row.user_id}</td>
                <td>{row.provider}</td>
                <td>{row.confidence ?? "n/a"}</td>
                <td>{new Date(row.created_at).toLocaleString()}</td>
                <td>{JSON.stringify(row.detected_items).slice(0, 80)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </AdminShell>
  );
}
