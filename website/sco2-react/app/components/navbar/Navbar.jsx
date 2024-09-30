const Navbar = () => {
    return (
        <div className="flex flex-wrap justify-between p-4 bg-gradient-to-r from-green-700 to-lime-400">
            <div className="flex flex-wrap place-items-center">
                <a href="" className="p-2 px-4 border-2 bg-white border-gray-200 rounded-full shadow-inner">Accueil</a>
            </div>
            <div className="flex flex-wrap place-items-center gap-4">
                <a href="" className="p-2 px-4 border-2 bg-white border-gray-200 rounded-full shadow-inner">Se connecter</a>
                <a href="" className="p-2 px-4 border-2 bg-white border-gray-200 rounded-full shadow-inner">S'inscrire</a>
            </div>
        </div>
    )
}

export default Navbar