'use client'; // Assurez-vous que ce composant est un Client Component si vous utilisez des gestionnaires d'événements

import React from 'react';
import Button from '../app/components/Button';

export default function Home() {
  return (
    <main className="bg-gray-50">
      {/* Bannière */}
      <div className="relative h-96 bg-green-800 flex items-center justify-center">
        <img className="absolute inset-0 w-full h-full object-cover opacity-50" src="./banner.png" alt="banner" />
        <div className="relative z-10 text-center">
          <img className="h-40 w-40 mx-auto mb-4" src="./LOGO_SCO2.svg" alt="logo" />
          <h1 className="text-4xl font-bold text-white">Bienvenue sur Social CO2</h1>
          <p className="text-xl text-white mt-2">Rejoignez la communauté qui agit pour la planète</p>
          <div className="mt-6">
            <Button>
              S'inscrire
            </Button>
            <Button>
              Se connecter
            </Button>
          </div>
        </div>
      </div>

      {/* Introduction */}
      <div className="container mx-auto px-4 py-12">
        <h2 className="text-3xl font-bold text-center text-gray-800">Qu'est-ce que Social CO2 ?</h2>
        <p className="mt-4 text-lg text-gray-600 text-center max-w-2xl mx-auto">
          Social CO2 est un réseau social écologique où les utilisateurs sont classés en fonction de leurs activités et posts. L'objectif est d'encourager les gens à adopter des comportements bénéfiques pour la planète. C'est un projet universitaire de 2ème année fait avec différentes technologies.
        </p>
      </div>

      {/* Fonctionnalités */}
      <div className="bg-white py-12">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold text-center text-gray-800">Nos Fonctionnalités</h2>
          <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-8">
            <FeatureCard
              image="./classement.PNG"
              title="Classement Écologique"
              description="Montez dans le classement en réalisant des actions écologiques et en partageant vos progrès."
            />
            <FeatureCard
              image="./commu.PNG"
              title="Communauté Engagée"
              description="Rejoignez une communauté de personnes partageant les mêmes valeurs et échangez des astuces écologiques."
            />
            <FeatureCard
              image="./messagerie1.png"
              title="Messagerie Écologique"
              description="Discutez avec d'autres membres et organisez des événements écologiques ensemble."
            />
          </div>
        </div>
      </div>

      {/* Contributeurs */}
      <div className="bg-gray-100 py-12">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold text-center text-gray-800">Contributeurs</h2>
          <p className="mt-4 text-lg text-gray-600 text-center max-w-2xl mx-auto">
            Ce projet a été réalisé grâce à la collaboration des membres suivants :
          </p>
          <div className="mt-8 flex flex-wrap justify-center gap-6">
            <ContributorCard
              name="Valentin Mary"
              role="Développeur Flutter Middleware et Front-End"
              avatar="./vlt.png"
            />
            <ContributorCard
              name="Luka Baudrant"
              role="Développeur Backend et React"
              avatar="./kezox.png"
            />
            <ContributorCard
              name="Jeremy Desbois"
              role="Analyste et soutien développeur Flutter"
              avatar="./gookd.png"
            />
            <ContributorCard
              name="David Baldo"
              role="Designer UI/UX de l'application"
              avatar="./david.png"
            />
          </div>
        </div>
      </div>

      {/* Lien vers GitHub */}
      <div className="bg-green-800 py-12">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl font-bold text-white">Contribuez au projet</h2>
          <p className="mt-4 text-lg text-white">
            Vous souhaitez contribuer à Social CO2 ? Rendez-vous sur notre dépôt GitHub pour participer au développement.
          </p>
          <div className="mt-6">
            <a
              href="https://github.com/VLD-dev-team/Social-Co2"
              target="_blank"
              rel="noopener noreferrer"
              className="bg-white text-green-600 px-6 py-2 rounded-full font-semibold hover:bg-green-50 transition duration-300 inline-block"
            >
              Voir sur GitHub
            </a>
          </div>
        </div>
      </div>

      {/* call to action ^^ */}
      <div className="bg-green-800 py-12">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl font-bold text-white">Prêt à faire la différence ?</h2>
          <p className="mt-4 text-lg text-white">Rejoignez-nous dès aujourd'hui et commencez à agir pour la planète.</p>
          <div className="mt-6">
            <Button>
              S'inscrire
            </Button>
          </div>
        </div>
      </div>
    </main>
  );
}

interface FeatureCardProps {
  image: string;
  title: string;
  description: string;
}
// Composant de carte de fonctionnalité
function FeatureCard({ image, title, description }: FeatureCardProps) {
  return (
    <div className="bg-gray-100 p-6 rounded-lg shadow-lg text-center">
      <img className="w-full h-48 object-cover rounded-lg" src={image} alt={title} />
      <h3 className="mt-4 text-xl font-bold text-gray-800">{title}</h3>
      <p className="mt-2 text-gray-600">{description}</p>
    </div>
  );
}

// Define the interface for the props
interface ContributorCardProps {
  name: string;
  role: string;
  avatar: string;
}

// Composant de carte de contributeur
function ContributorCard({ name, role, avatar }: ContributorCardProps) {
  return (
    <div className="bg-white p-6 rounded-lg shadow-lg text-center w-64">
      <img className="w-24 h-24 rounded-full mx-auto mb-4" src={avatar} alt={name} />
      <h3 className="text-xl font-bold text-gray-800">{name}</h3>
      <p className="text-gray-600">{role}</p>
    </div>
  );
}