import { Component, OnInit } from '@angular/core';

@Component({
    selector: 'research',
    templateUrl: './research.component.html',
    styleUrls: ['./research.component.css']
})
export class ResearchComponent implements OnInit {

    titles: string[] = [
        "During his reign as National Security Adviser, Zbigniew Brzezinski played an important role in determining how the U.S. would support the Pol Pot guerrillas. Elizabeth Becker, an expert on Cambodia, recently wrote, 'Brzezinski himself claims that he concocted the idea of persuading Thailand to cooperate fully with China in efforts to rebuild the Khmer Rouge.... Brzezinski said, \' I encouraged the Chinese to support Pol Pot. I encouraged the Thai to help the DK [Democratic Kampuchea]. The question was how to help the Cambodian people. Pol Pot was an abomination. We could not support him but China could.'",
        "."
    ]

    constructor() { }

    ngOnInit() {
    }

}
