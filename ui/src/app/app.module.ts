import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { SubmissionComponent } from './submission/submission.component';
import { ResearchComponent } from './research/research.component';

@NgModule({
  declarations: [
    AppComponent,
    SubmissionComponent,
    ResearchComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
