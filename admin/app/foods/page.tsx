import { AdminShell } from "../../components/AdminShell";
import { supabaseAdmin } from "../../lib/supabase";

export default async function FoodsPage() {
  const { data } = await supabaseAdmin.from("foods").select("id,name,category,cuisine,calories,protein,carbs,fat,verified").limit(100);

  return (
    <AdminShell>
      <h1>Food database</h1>
      <div className="card">
        <table>
          <thead><tr><th>Food</th><th>Category</th><th>Cuisine</th><th>Kcal</th><th>Macros</th><th>Status</th></tr></thead>
          <tbody>
            {(data ?? []).map((food) => (
              <tr key={food.id}>
                <td>{food.name}</td>
                <td>{food.category}</td>
                <td>{food.cuisine}</td>
                <td>{food.calories}</td>
                <td>P {food.protein} C {food.carbs} F {food.fat}</td>
                <td>{food.verified ? "Verified" : "Draft"}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </AdminShell>
  );
}
