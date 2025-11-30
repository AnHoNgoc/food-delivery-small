import { NavLink } from "react-router-dom";

const Nav = () => {

    const navItems = [
        { name: "Home", path: "/" },
        { name: "Support", path: "/support" },
        { name: "Privacy Policy", path: "/privacy" }
    ];

    return (
        <nav className="bg-gray-100 dark:bg-gray-900 w-full shadow">
            <div className="max-w-7xl mx-auto px-6 py-3">
                <ul className="flex justify-center space-x-6">
                    {navItems.map((item) => (
                        <li key={item.name}>
                            <NavLink
                                to={item.path}
                                end
                                className={({ isActive }) =>
                                    `px-3 py-2 rounded-lg font-medium transition ${isActive
                                        ? "text-blue-600 bg-blue-100 dark:bg-gray-800"
                                        : "text-gray-700 dark:text-gray-300 hover:text-blue-500"
                                    }`
                                }
                            >
                                {item.name}
                            </NavLink>
                        </li>
                    ))}
                </ul>
            </div>
        </nav>
    );
};

export default Nav;