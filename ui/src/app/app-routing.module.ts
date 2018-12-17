import { NgModule } from '@angular/core';
import { Routes, RouterModule, ExtraOptions } from '@angular/router';
import { ResearchComponent } from "./research/research.component";

const routes: Routes = [
    { path: '', redirectTo: 'research', pathMatch: 'full' },
    { path: 'research', component: ResearchComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes, <ExtraOptions>{
      enableTracing: true
  })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
