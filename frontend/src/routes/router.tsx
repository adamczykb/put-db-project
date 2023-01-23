import { ReactElement } from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Home from "../components/home/Home";
import Employee from "../components/Employee/Employee";
import Travel from "../components/Travels/Travel";
import TravelForm from "../components/Travels/Travel_Form";
import PilotsView from "../components/Pilots/Pilots";
import AddPilot from "../components/Pilots/AddPilot";
import UpdatePilot from "../components/Pilots/UpdatePilot";
import AccomodationView from "../components/Accomodation/Accomodation";
import AddClients from "../components/home/AddClient";
import UpdateClient from "../components/home/UpdateClient";
import AddAccommodanion from "../components/Accomodation/AddAccomodation";
import TransportCompanyView from "../components/TransportCompany/TransportCompany";
import AddEmployee from "../components/Employee/AddEmployee";



const IndexRouter: React.FC = (): ReactElement => {
    return (
        <BrowserRouter>
            <Routes>
                <Route path={"/"} element={<Travel />} />
                <Route path={"/klienty"} element={<Home />} />
                <Route path={"/klienty/dodaj"} element={<AddClients />} />
                <Route path={"/klienty/edycja/:pesel"} element={<UpdateClient />} />
                <Route path={"/pracownicy"} element={<Employee />} />
                <Route path={"/pracownicy/dodaj"} element={<AddEmployee />} />
                <Route path={"/podrozy/dodaniePodrozy"} element={<TravelForm />} />
                <Route path={"/przewodnicy"} element={<PilotsView />} />
                <Route path={"/przewodnicy/dodaj"} element={<AddPilot />} />
                <Route path={"/przewodnicy/edycja/:id"} element={<UpdatePilot />} />
                <Route path={"/zakwaterowanie"} element={<AccomodationView />} />
                <Route path={"/zakwaterowanie/dodaj"} element={<AddAccommodanion />} />
                <Route path={"/zakwaterowanie/dodaj"} element={<AddAccommodanion />} />
                <Route path={"/firma_transportowa"} element={<TransportCompanyView/>}/>
            </Routes>
        </BrowserRouter>
    );
};
export default IndexRouter;
