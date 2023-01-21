import { ReactElement } from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Home from "../components/home/Home";
import Employee from "../components/Employee/Employee";
import Travel from "../components/Travels/Travel";
import TravelForm from "../components/Travels/Travel_Form";
import ClientForm from "../components/home/Client_Form";
import PilotsView from "../components/Pilots/Pilots";

const IndexRouter: React.FC = (): ReactElement => {
    return (
        <BrowserRouter>
            <Routes>
                <Route path={"/"} element={<Travel />} />
                <Route path={"/klienty"} element={<Home />} />
                <Route path={"/pracowniki"} element={<Employee />} />
                <Route path={"/podrozy/dodaniePodrozy"} element={<TravelForm />} />
                <Route path={"/przewodnicy"} element={<PilotsView />} />
                <Route path={"/przewodnicy/edycja/"} element={<PilotsView />} />
            </Routes>
        </BrowserRouter>
    );
};
export default IndexRouter;
