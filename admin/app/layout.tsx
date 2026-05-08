import "./styles.css";
import type { ReactNode } from "react";

export const metadata = {
  title: "Aura Diet Admin",
  description: "Admin dashboard for Aura Diet",
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
