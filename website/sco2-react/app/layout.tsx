import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Social CO2 - Accueil",
  description: "Bienvenue sur le site web de SCO2",
  icons: {
    icon: "/LOGO_SCO2.svg", // Chemin vers votre fichier favicon dans le dossier public
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="fr">
      <body className={inter.className}>{children}</body>
    </html>
  );
}