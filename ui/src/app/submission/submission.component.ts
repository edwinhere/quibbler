import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'submission',
  templateUrl: './submission.component.html',
  styleUrls: ['./submission.component.css']
})
export class SubmissionComponent implements OnInit {

  @Input()
  title: string;

  constructor() { }

  ngOnInit() {
  }

}
