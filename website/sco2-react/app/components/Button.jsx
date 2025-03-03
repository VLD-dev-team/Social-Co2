'use client';
export default function Button({children}){ 
    return(
        <button className="bg-white text-green-600 px-6 py-2 rounded-full font-semibold hover:bg-green-50 transition duration-300 m-3" onClick={event => window.location.href='https://app.social-co2.vld-group.com/'}>
            {children}
        </button>

    )
};