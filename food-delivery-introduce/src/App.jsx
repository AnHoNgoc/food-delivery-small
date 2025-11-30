
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Home from "./pages/Home";
import Support from "./pages/Support";
import PrivacyPolicy from "./pages/PrivacyPolicy";
import Navbar from "./components/Nav";

function App() {
  return (
    <BrowserRouter>
      <Navbar />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/support" element={<Support />} />
        <Route path="/privacy" element={<PrivacyPolicy />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
