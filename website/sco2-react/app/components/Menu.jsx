 export default function Menu(){
    return (
            <div className="grid grid-rows-3 grid-flow-col gap-4 bg-orange-100 pr-10 pt-3">
            <div className="row-span-3"></div>
                <div className="flex col-span-2 w-auto h-20 bg-white border rounded-full px-10 items-center justify-center"><p className="text-5xl font-sans">C'est quoi SCO2 ?</p></div>
                <div className="row-span-2 col-span-2 w-auto h-20 bg-orange-200 border border rounded-full flex items-center justify-center px-10">
                    <p>Le réseau social Social CO², abrégé SCO2, se distingue par sa vocation écologique et responsable, reposant sur un système de scoring personnalisé attribué à chaque utilisateur. Cette plateforme innovante se caractérise également par son suivi, en temps réel, de l’impact de chaque individu sur son environnement. De plus, et grâce à son interopérabilité, SCO2 est accessible de manière fluide et efficace tant sur les appareils mobiles tels que les smartphones, que sur les ordinateurs personnels.</p></div>
                </div> 
    );
}
