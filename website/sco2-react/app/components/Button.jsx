'use client';
export default function Button({children}){ 
    return(
        <button onClick={event => window.location.href='https://app.social-co2.vld-group.com' }>
            {children}
        </button>

    )
};