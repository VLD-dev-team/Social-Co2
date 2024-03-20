'use client';
export default function Button({children,message}){ /**/ 
    return(
        <button onClick={function Handleclick(){
            alert(message);
        }}>
            {children}
        </button>

    )
};